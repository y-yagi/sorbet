

rbenv_versions = {
    "1.1.2": {
        "url": "https://github.com/rbenv/rbenv/archive/v1.1.2.tar.gz",
        "sha": "80ad89ffe04c0b481503bd375f05c212bbc7d44ef5f5e649e0acdf25eba86736",
    }
}


def download_rbenv(repo_ctx, rbenv_version):
    info = rbenv_versions[rbenv_version]

    if info == None:
        fail(msg="Unknown rbenv version `{}`".format(rbenv_version))

    repo_ctx.report_progress("downloading rbenv-{}".format(rbenv_version))

    repo_ctx.download_and_extract(
        url = info["url"],
        sha256 = info["sha"],
        type = "tar.gz",
    )

    return "rbenv-{}".format(rbenv_version)


def build_rbenv(repo_ctx, rbenv_version, path):
    repo_ctx.report_progress("building rbenv-{}".format(rbenv_version))

    repo_ctx.template(
        "build_rbenv.sh",
        "third_party/ruby/build_rbenv.sh.tpl",
        substitutions = {
            "%{rbenv_path}": path
        },
        executable = True
    )

    repo_ctx.execute(["./build_rbenv.sh"], quiet = not repo_ctx.attr.debug)


def setup_rbenv(repo_ctx, rbenv_version):
    path = download_rbenv(repo_ctx, rbenv_version)
    build_rbenv(repo_ctx, rbenv_version, path)


ruby_versions = {

    "2.4.3": {
        "url": "https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.3.tar.gz",
        "sha": "fd0375582c92045aa7d31854e724471fb469e11a4b08ff334d39052ccaaa3a98",
    }

}


def download_ruby(repo_ctx, ruby_version):
    repo_ctx.report_progress("downloading ruby-{}".format(ruby_version)) 

    info = ruby_versions[ruby_version]
    if info == None:
        fail(msg="Unknown ruby version `{}`".format(ruby_version))

    repo_ctx.download_and_extract(
        info["url"],
        sha256 = info["sha"],
        type = "tar.gz",
    )

    return "ruby-{}".format(ruby_version)


def build_ruby(repo_ctx, ruby_version, path):
    repo_ctx.report_progress("building ruby-{}".format(ruby_version)) 

    prefix = repo_ctx.path(ruby_version)

    content = "\n".join([
        "#!/bin/bash",
        "",
        "set -euo pipefail",
        "",
        "cd {}".format(path),
        "./configure --prefix={}".format(prefix),
        "make",
        "make install",
    ])

    repo_ctx.file(
        "build_ruby.sh",
        content = content,
        executable = True,
    )

    repo_ctx.execute(["./build_ruby.sh"], quiet = not repo_ctx.attr.debug)


def setup_ruby(repo_ctx, ruby_version):
    path = download_ruby(repo_ctx, ruby_version)
    build_ruby(repo_ctx, ruby_version, path)


def _ruby_toolchain_impl(repo_ctx):

    setup_rbenv(repo_ctx, repo_ctx.attr.rbenv_version)

    for ruby_version in repo_ctx.attr.ruby_versions:
        setup_ruby(repo_ctx, ruby_version)

    return None

ruby_toolchain = repository_rule(
    implementation = _ruby_toolchain_impl,
    local = True,
    attrs = {
        "ruby_versions": attr.string_list(
            default=["2.4.3"],
            non_empty=True,
            doc="A list of ruby versions to install",
        ),
        "rbenv_version": attr.string(
            default="1.1.2",
        ),
        "debug": attr.bool(
            default=False,
            doc="Dump output to stdout while building",
        )
    },
)
