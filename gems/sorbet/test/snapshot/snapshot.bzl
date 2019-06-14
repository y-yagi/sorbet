
def snapshot_tests(test_paths):
    """
    Define a bunch of snapshot tests all at once. The paths must all conform to
    the format expected by test_path.
    """

    test_names = []

    for test_path in test_paths:
        test_names.append(snapshot_test(test_path))

    return test_names

def snapshot_test(test_path):
    """
    test_path is of the form `total/test` or `partial/test`.
    """

    test_name = 'test_{}'.format(test_path)

    # The vendor/cache tree sits in a mirrored path to the Gemfile.lock
    vendor_cache = "@gems//gems/sorbet/test/snapshot/{}/src/vendor/cache".format(test_path)

    native.sh_test(
        name = test_name,
        srcs = [ "test_one_bazel.sh" ],
        data = [
            "//main:sorbet",
            "//gems/sorbet:sorbet",
            vendor_cache,
            "{}:token".format(vendor_cache),
            "@ruby_2_4_3//:ruby",

            "@gems//bundler:bundle",
            "@gems//bundler:bundler",
            "@gems//bundler:bundle-env",

            "{}".format(test_path),
        ],
        deps = [
            ":logging",
        ],
        args = [
            "$(location @ruby_2_4_3//:ruby)",
            "$(location @gems//bundler:bundle)",
            "$(location {}:token)".format(vendor_cache),
            test_path,
        ],
        timeout = "short",
    )

    return test_name
