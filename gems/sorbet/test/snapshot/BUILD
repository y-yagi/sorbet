load(":snapshot.bzl", "snapshot_tests")

sh_library(
    name = "logging",
    data = [ "logging.sh" ],
)

test_suite(
    name = "snapshot",
    # NOTE: Once all the tests are supported, the explicit enumeration can be
    # replaced with the following:
    # tests = snapshot_tests(glob([ "partial/*", "total/*" ], exclude_directories = 0)),
    tests = snapshot_tests([
        "partial/bad-hash",
        "partial/bad-t",
        "partial/create-config",
        "partial/explosive-object",
        "partial/fake-object",
        "partial/fake-rails",
        "partial/non-utf-8-file",
        "partial/real_singleton_class",
        "partial/require_relative",
        "partial/stack_master",
        "partial/typed-ignore",

        # Unknown
        # -------
        # "total/empty",

        # Gem dependency failures
        # -----------------------
        # "partial/codecov",
        # "partial/partially-sigged",
        # "partial/rails-double-require",
        # "partial/stupidedi",
        # "partial/rspec-lots",
        # "partial/webmock",

        # Local gem source problems with @installed_gems
        # ----------------------------------------------
        # "partial/local_gem",
    ]),
)
