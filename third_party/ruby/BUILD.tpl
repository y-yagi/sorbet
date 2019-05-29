
genrule(
    name = "ruby",
    tools = [":build_ruby.sh", ":ruby_env.sh", "@boringssl//:crypto"],
    srcs =
        glob(["source/**/*"]),
    outs = [
        "bin/ruby",
        "bin/irb",
    ],
    cmd = "$(location build_ruby.sh)",
)
