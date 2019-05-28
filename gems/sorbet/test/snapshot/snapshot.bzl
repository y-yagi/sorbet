
def snapshot_tests(paths, test_prefix):

    tests = []

    for path in paths:
        test_name = 'test_{}/{}'.format(test_prefix, path)

        data = [
            "@ruby_2_4_3//:ruby",
            "//main:sorbet",
            "//gems/sorbet:sorbet",
            ":logging"
        ] + native.glob(['{}/**/*'.format(path)])

        native.sh_test(
            name = test_name,
            srcs = ["test_one.sh"],
            data = data,
            args = [path],
        )

        tests.append(test_name)

    return tests
