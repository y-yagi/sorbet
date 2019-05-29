
load("@rules_foreign_cc//tools/build_defs:configure.bzl", "configure_make")

filegroup(
    name = "ruby_all",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

configure_make(
    name = "ruby_configure",
    lib_source = ":ruby_all",
    out_lib_dir = "lib",
)
