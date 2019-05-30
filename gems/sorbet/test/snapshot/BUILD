load(":snapshot.bzl", "snapshot_tests")

sh_library(
    name = "logging",
    data = [ "logging.sh" ],
)

test_suite(
    name = "snapshot",
    tests = snapshot_tests(
        paths = glob(
            [
                "partial/*",
                "total/*",
            ],
            exclude_directories = 0,
        ),
        test_prefix = 'snapshot',
    ),
)
