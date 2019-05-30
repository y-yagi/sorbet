
def _impl(repo_ctx):

    res = repo_ctx.execute( ["ls"], quiet = False)

    print(Label("//gems").workspace_name)

    paths = [ repo_ctx.path(Label(path).workspace_root) for path in repo_ctx.attr.gemfile_search_paths ]

    print(paths)

    res = repo_ctx.execute(
        ["find"] + paths + ["-name","Gemfile.lock"],
        quiet = False,
    )

    if res.return_code != 0:
        fail(msg="Failed to run `find`:\n{}".format(res.stderr))

    print(res.stdout)


gemfile_lock_deps = repository_rule(
    implementation = _impl,
    local = True,
    attrs = {
        "gemfile_search_paths": attr.string_list(
            default = [], 
            doc = "paths to search for Gemfile.lock files",
        ),
    },
)
