
filegroup(
    name = "runtime_deps",
    srcs = [
        "exe/bundle",
        "exe/bundler",
    ] + glob([ "lib/**/*.rb" ]),
    visibility = [ "//visibility:public" ],
)

sh_binary(
    name = "bundle",
    data = [ ":runtime_deps" ],
    srcs = [ "bundle.sh" ],
    visibility = [ "//visibility:public" ],
)
