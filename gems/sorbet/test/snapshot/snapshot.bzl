
def snapshot_tests(paths, test_prefix):

    tests = []

    for path in paths:
        test_name = 'test_{}/{}'.format(test_prefix, path)

        vendor_cache = "@installed_gems//gems/sorbet/test/snapshot/{}/src/vendor/cache".format(path)

        native.sh_test(
            name = test_name,
            srcs = [ "test_one_bazel.sh" ],
            data = [
                "//main:sorbet",
                "//gems/sorbet:sorbet",
                "{}/src".format(path),
                vendor_cache,
                "{}:token".format(vendor_cache),
                "@ruby_2_4_3//:ruby",
                "@installed_gems//bundler:bundle",
                "@installed_gems//bundler:bundle-env",
            ],
            deps = [
                ":logging",
            ],
            args = [
                "$(location @ruby_2_4_3//:ruby)",
                "$(location @installed_gems//bundler:bundle)",
                "$(location {}:token)".format(vendor_cache),
                path,
            ],
            timeout = "short",
        )

        tests.append(test_name)

    return tests
