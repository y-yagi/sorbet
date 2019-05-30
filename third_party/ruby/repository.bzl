

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


def _fetch_package(repo_ctx, info):
    """
    Download a specific package version from rubygems.org. Returns the formatted
    package name, and the sha256 of the downloaded archive.
    """

    package_name = _format_package(info)
    output = "gems/{}".format(package_name)

    url = "https://rubygems.org/downloads/{}.gem".format(package_name)

    result = repo_ctx.download_and_extract(
        output = output,
        url = url,
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
    return "\"//gems/{}\"".format(_format_package(info))


def _package_to_path(repo_ctx, info):
    """
    Turn a package description into a path that can be used in an environment
    script. Returns a string.
    """
    return "external/{}/gems/{}/lib".format(repo_ctx.name, _format_package(info))


def _generate_gemfile_rules(repo_ctx, gemfile_lock, deps):
    """
    Generates a BUILD file in the same location as the Gemfile.lock file in the
    original repository, 
    """

    package = Label(gemfile_lock).package

    ruby_lib = ":".join([ _package_to_path(repo_ctx, info) for info in deps ])


    env_deps = ", ".join([ _package_to_dep(info) for info in deps ])

    repo_ctx.template(
        "{}/BUILD".format(package),
        Label("//third_party/ruby:Gemfile-env.BUILD"),
        substitutions = {
            "%{ruby_lib}": ruby_lib,
            "%{env_deps}": env_deps,
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

    all_deps = {}
    gemfile_deps = {}

    # parse all gemfiles, and unique dependencies
    for gemfile_lock in repo_ctx.attr.gemfile_locks:
        deps = _parse_gemfile_lock(_read_file(repo_ctx, Label(gemfile_lock)))

        gemfile_deps[gemfile_lock] = deps

        for dep in deps:
            name = dep["name"]
            if all_deps.get(name) == None:
                all_deps[name] = dep


    # fetch unique dependencies
    for key, info in all_deps.items():
        # TODO: make use of the shas in the return value of _impl
        _sha = _fetch_package(repo_ctx, info)

    for gemfile_lock, deps in gemfile_deps.items():
        _generate_gemfile_rules(repo_ctx, gemfile_lock, deps)

    return None


gemfile_lock_deps = repository_rule(
    implementation = _impl,
    local = True,
    attrs = {
        "gemfile_locks": attr.string_list(
            default = [], 
            doc = "Gemfile.lock files to download the dependencies of",
        ),
    },
)
