
filegroup(
    name = "ruby",
    srcs = glob([
        "bin/**/*",
        "include/**/*",
        "lib/**/*",
        "share/**/*",
        "ruby_env.sh"
    ]),
    visibility = ["//visibility:public"],
)
