
def _package_dep(package_name, dep):
    return "ruby/{}/{}".format(package_name, dep)

def build_ruby_toolchain(package_name):

    ruby_files = Label("@{}//:ruby_all".format(package_name))

    native.cc_library(
        name = _package_dep(package_name, "libruby"),
        deps = [ruby_files],
    )
