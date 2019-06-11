
def snapshot_tests(test_paths):
    test_names = []

    for test_path in test_paths:
        test_names.append(snapshot_test(test_path))

    return test_names

def snapshot_test(test_path):
    """
    test_path is of the form `total/test` or `partial/test`.
    """

    test_name = 'test_{}'.format(test_path)

    vendor_cache = "@installed_gems//gems/sorbet/test/snapshot/{}/src/vendor/cache".format(test_path)

    expected_dep = []
    expected = native.glob([ "{}/expected" ])
    if len(expected) > 0:
        expected_dep = [ "{}/expected".format(test_path) ]

    native.sh_test(
        name = test_name,
        srcs = [ "test_one_bazel.sh" ],
        data = [
            "//main:sorbet",
            "//gems/sorbet:sorbet",
            "{}/src".format(test_path),
            vendor_cache,
            "{}:token".format(vendor_cache),
            "@ruby_2_4_3//:ruby",
            "@installed_gems//bundler:bundle",
            "@installed_gems//bundler:bundle-env",
        ] + expected_dep,
        deps = [
            ":logging",
        ],
        args = [
            "$(location @ruby_2_4_3//:ruby)",
            "$(location @installed_gems//bundler:bundle)",
            "$(location {}:token)".format(vendor_cache),
            test_path,
        ],
        timeout = "short",
    )

    return test_name
