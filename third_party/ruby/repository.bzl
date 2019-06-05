

def _read_file(repo_ctx, label):
    """
    Bazel-0.21.0 lacks `repo_ctx.read`, so this simulates it by briefly
    symlinking the file into the current repo, cat-ing it, and then removing
    the symlink.
    """

    repo_ctx.symlink(label, "tmp")

    result = repo_ctx.execute(["cat", "tmp"])

    if result.return_code != 0:
        fail("Failed to read file `{}`".format(label))

    repo_ctx.execute(["rm", "tmp"])

    return result.stdout


def _format_package(info):
    return "{}-{}".format(info["name"], info["version"])


def _parse_package(line):
    """
    Parse an exact package specification from a single line of a Gemfile.lock.
    If the line did not contain an exact specification (something of the form
    `package (version)`, return None.
    """

    prefix = line[0:4]
    if not prefix.isspace():
        return None

    suffix = line[4:]
    if suffix[0].isspace():
        return None

    version_start = suffix.find(' (')
    if version_start < 0:
        return None

    package = suffix[0:version_start]
    version = suffix[version_start+2:-1]

    return { "name": package, "version": version }


def _parse_gemfile_lock(content):
    """
    Find lines in the content of a Gemfile.lock that look like package
    constraints.
    """

    packages = []

    for line in content.splitlines():
        info = _parse_package(line)
        if info != None:
            packages.append(info)

    return packages


def _fetch_package(repo_ctx, package_name, sha):
    """
    Download a specific package version from rubygems.org. Returns the formatted
    package name, and the sha256 of the downloaded archive.
    """

    output = "gems/{}".format(package_name)

    url = "https://rubygems.org/downloads/{}.gem".format(package_name)

    # default the sha to "" when it's unknown
    if sha == None:
        sha = ""

    result = repo_ctx.download_and_extract(
        output = output,
        url = url,
        sha256 = sha,
        type = "tar",
    )

    repo_ctx.execute(["./setup_gem.sh", output])

    repo_ctx.template(
        "{}/BUILD".format(output),
        Label("//third_party/ruby:gem.BUILD"),
        substitutions = {
            "%{gem_name}": package_name
        },
        executable = False,
    )

    return { "name": package_name, "sha": result.sha256 }


def _package_to_dep(info):
    """
    Make a downloaded gem dependency for the given package info. Returns a
    quoted string.
    """
    package_name = _format_package(info)
    return "\"//gems/{}:{}\"".format(package_name, package_name)


def _package_to_path(repo_ctx, info):
    """
    Turn a package description into a path that can be used in an environment
    script. Returns a string.
    """
    return "\$$base_dir/Gemfile.lock-env.runfiles/{}/gems/{}/lib".format(repo_ctx.name, _format_package(info))


def _generate_gemfile_rules(repo_ctx, gemfile_lock, deps):
    """
    Generates a BUILD file in the same location as the Gemfile.lock file in the
    original repository, 
    """

    # TODO: need to consider more than just the package when inventing the label
    # for the environment script
    package = Label(gemfile_lock).package

    ruby_lib = ":".join([ _package_to_path(repo_ctx, info) for info in deps ])

    env_deps = ", ".join([ _package_to_dep(info) for info in deps ])

    print('ruby_lib = {}'.format(ruby_lib))
    print('env_deps = {}'.format(env_deps))

    repo_ctx.template(
        "{}/BUILD".format(package),
        Label("//third_party/ruby:Gemfile-env.BUILD"),
        substitutions = {
            "%{env_deps}": env_deps,
            "%{ruby_lib}": ruby_lib,
        },
        executable = False,
    )


def _impl(repo_ctx):

    # used for setting up individual gems
    repo_ctx.template(
        "setup_gem.sh",
        Label("//third_party/ruby:setup_gem.sh"),
        executable = True,
    )

    # As a special case, we always install bundler into every environment
    bundler_info = { "name": "bundler", "version": "1.17.1" }

    all_deps = { "bundler-1.17.1": True }

    gemfile_deps = {}

    # parse all gemfiles, and unique dependencies
    for gemfile_lock in repo_ctx.attr.gemfile_locks:
        deps = _parse_gemfile_lock(_read_file(repo_ctx, Label(gemfile_lock)))

        gemfile_deps[gemfile_lock] = deps

        for dep in deps:
            package_name = _format_package(dep)
            all_deps[package_name] = True

    # fetch unique dependencies
    known_shas = {}
    fetched = False
    for package_name in all_deps.keys():

        known_sha = repo_ctx.attr.gems.get(package_name)
        if known_sha == None:
            fetched = True

        result = _fetch_package(repo_ctx, package_name, known_sha)

        known_shas[package_name] = result["sha"]

    # generate gemfile environments
    for gemfile_lock, deps in gemfile_deps.items():
        _generate_gemfile_rules(repo_ctx, gemfile_lock, [bundler_info] + deps)

    # When we've fetched gems that lack sha256 value, emit attributes that would
    # make this hermetic.
    if fetched:
        return {
            "name": repo_ctx.attr.name,
            "gemfile_locks": repo_ctx.attr.gemfile_locks,
            "gems": known_shas,
        }
    else:
        return None


gemfile_lock_deps = repository_rule(
    implementation = _impl,
    local = True,
    attrs = {
        "gemfile_locks": attr.string_list(
            default = [],
            doc = "Gemfile.lock files to download the dependencies of",
        ),

        "gems": attr.string_dict(
            default = {},
            doc = "Specific gem versions and sha256 values",
        ),
    },
)
