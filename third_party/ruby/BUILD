licenses(["notice"])

sh_test(
    name = "test_miniruby",
    srcs = [ "test-miniruby.sh" ],
    data = [ "@ruby_2_4_3//:miniruby" ],
    args = [ "$(location @ruby_2_4_3//:miniruby)" ],
)
