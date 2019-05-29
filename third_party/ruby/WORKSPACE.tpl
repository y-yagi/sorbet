
workspace(name = "%{workspace_name}")

git_repository(
    name = "boringssl",
    commit = "70812081b52398425183b74bea64572b477001f8",
    remote = "https://boringssl.googlesource.com/boringssl",
)
