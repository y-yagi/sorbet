
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
        "%{ruby_prefix}": prefix,
    }

    # environment management
    repo_ctx.template(
        "ruby_env.sh",
        Label("//third_party/ruby:ruby_env.sh.tpl"),
        substitutions = substitutions,
        executable = True,
    )

    # ruby installer
    repo_ctx.template(
        "build_ruby.sh",
        Label("//third_party/ruby:build_ruby.sh.tpl"),
        substitutions = substitutions,
        executable = True,
    )

    # bundler installer
    repo_ctx.template(
        "build_bundler.sh",
        Label("//third_party/ruby:build_bundler.sh.tpl"),
        substitutions = substitutions,
        executable = True,
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
        output = "source",
        sha256 = info["sha"],
        type = "tar.gz",
        stripPrefix = "ruby-{}".format(ruby_version),
    )

def _build_ruby(repo_ctx, ruby_version):
    """
    Given a path to a downloade and extracted ruby source distribution, build
    it.
    """

    repo_ctx.report_progress("building ruby-{}".format(ruby_version)) 

    repo_ctx.execute(["./build_ruby.sh"], quiet = not repo_ctx.attr.debug)


def _install_bundler(repo_ctx, ruby_version):
    """
    Given a path to the ruby distirbution, install bundler.
    """

    repo_ctx.report_progress("installing bundler")

    repo_ctx.execute("./build_bundler.sh", quiet = not repo_ctx.attr.debug)


def _setup_ruby(repo_ctx, ruby_version):
    _install_scripts(repo_ctx, ruby_version)
    _download_ruby(repo_ctx, ruby_version)
    _build_ruby(repo_ctx, ruby_version)
    _install_bundler(repo_ctx, ruby_version)


def _ruby_toolchain_impl(repo_ctx):

    repo_ctx.template("BUILD", Label("//third_party/ruby:BUILD.tpl"))

    _setup_ruby(repo_ctx, repo_ctx.attr.ruby_version)

    return None

ruby_toolchain = repository_rule(
    implementation = _ruby_toolchain_impl,
    local = False,
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
