
_ruby_versions = {

    "2.4.3": {
        "url": "https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.3.tar.gz",
        "sha": "fd0375582c92045aa7d31854e724471fb469e11a4b08ff334d39052ccaaa3a98",
    }

}


def _install_scripts(repo_ctx, ruby_version):

    # TODO: there must be a better way to convert a path to a string
    prefix = "{}".format(repo_ctx.path("."))

    substitutions = {
        "%{workspace_name}": repo_ctx.name,
        "%{ruby_version}": ruby_version,
    }

    # WORKSPACE file
    repo_ctx.template(
        "WORKSPACE",
        Label("//third_party/ruby:WORKSPACE.tpl"),
        substitutions = substitutions,
        executable = False,
    )

    # top-level BUILD
    repo_ctx.template(
        "BUILD",
        Label("//third_party/ruby:BUILD.tpl"),
        substitutions = substitutions,
        executable = False,
    )

    # top-level rules
    repo_ctx.template(
        "ruby.bzl",
        Label("//third_party/ruby:ruby.bzl"),
        substitutions = substitutions,
        executable = False,
    )

    # ext configuration
    repo_ctx.template(
        "ext/Setup",
        Label("//third_party/ruby:Setup"),
        substitutions = substitutions,
        executable = False,
    )

def _download_ruby(repo_ctx, ruby_version):
    """
    Download the ruby version specified, and return the directory where it has
    been extracted.
    """
    repo_ctx.report_progress("downloading ruby-{}".format(ruby_version)) 

    info = _ruby_versions[ruby_version]
    if info == None:
        fail(msg="Unknown ruby version `{}`".format(ruby_version))

    repo_ctx.download_and_extract(
        info["url"],
        sha256 = info["sha"],
        type = "tar.gz",
        stripPrefix = "ruby-{}".format(ruby_version),
    )

def _ruby_toolchain_impl(repo_ctx):
    ruby_version = repo_ctx.attr.ruby_version

    _install_scripts(repo_ctx, ruby_version)
    _download_ruby(repo_ctx, ruby_version)

    return None

ruby_toolchain = repository_rule(
    implementation = _ruby_toolchain_impl,
    local = True,
    attrs = {
        "ruby_version": attr.string(
            mandatory=True,
            doc="A list of ruby versions to install",
        ),
        "debug": attr.bool(
            default=False,
            doc="Dump output to stdout while building",
        )
    },
)
