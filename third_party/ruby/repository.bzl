

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
    Download a specific package version from rubygems.org
    """

    output = _format_package(info)

    url = "https://rubygems.org/downloads/{}.gem".format(output)

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
            "%{gem_name}": output
        },
        executable = False,
    )

    return result.sha256


def _gather_dependencies(repo_ctx, gemfile_lock):
    packages = _parse_gemfile_lock(_read_file(repo_ctx, Label(gemfile_lock)))

    shas = []

    for info in packages:
        shas.append({
            "name": _format_package(info),
            "sha": _fetch_package(repo_ctx, info),
        })

    return shas


def _impl(repo_ctx):

    # used for setting up individual gems
    repo_ctx.template(
        "setup_gem.sh",
        Label("//third_party/ruby:setup_gem.sh"),
        executable = True,
    )

    results = []

    for gemfile_lock in repo_ctx.attr.gemfile_locks:
        results.extend(_gather_dependencies(repo_ctx, gemfile_lock))

    # TODO: return something else to make use of the shas collected for all of
    # the required gems

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
