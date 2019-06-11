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
    tests = snapshot_tests(glob(
        [ "partial/*", "total/*" ],
        exclude = [
        # Bundler gem path problem with tracepoint
        # ----------------------------------------
        # "total/empty",

        # Gem dependency failures
        # -----------------------
        "partial/codecov",
        "partial/partially-sigged",
        "partial/rails-double-require",
        "partial/stupidedi",
        "partial/rspec-lots",
        "partial/webmock",

        # Local gem source problems with @installed_gems
        # ----------------------------------------------
        "partial/local_gem",
        ],
        exclude_directories = 0
    )),
)
