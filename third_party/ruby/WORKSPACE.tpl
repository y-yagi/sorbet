
workspace(name = "%{workspace_name}")

git_repository(
    name = "boringssl",
    commit = "70812081b52398425183b74bea64572b477001f8",
    remote = "https://boringssl.googlesource.com/boringssl",
)

git_repository(
    name="rules_foreign_cc",
    remote="https://github.com/bazelbuild/rules_foreign_cc.git",
    commit="a3593905f73ce19c09d21f9968f1d3f5bc115157",
)
