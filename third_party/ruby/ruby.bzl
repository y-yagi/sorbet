
def _impl(ctx):
    print('libffi')


    ctx.actions.run_shell(
        tools = [
            "ext/fiddle/libffi-3.2.1/configure",
        ],
        outs = [
            "ext/fiddle/libffi-3.2.1/x86_64-apple-darwin18.6.0/include/ffi.h",
            "ext/fiddle/libffi-3.2.1/x86_64-apple-darwin18.6.0/fficonfig.h",
            "ext/fiddle/libffi-3.2.1/x86_64-apple-darwin18.6.0/config.status",
            "ext/fiddle/libffi-3.2.1/x86_64-apple-darwin18.6.0/src/ffitarget.h",
        ],
        srcs = ctx.attr._srcs,
        cmd = """
          export CFLAGS=$(CC_FLAGS)
          pushd $$(dirname $(location ext/fiddle/libffi-3.2.1/configure))
          ./configure
        """,
    )

build_libffi = rule(
    implementation = _impl,
    attrs = {
        "_srcs": attr.string_list(
            default = native.glob([
                "ext/fiddle/libffi-3.2.1/src/**/*.h",
                "ext/fiddle/libffi-3.2.1/**/*.in",
                "ext/fiddle/libffi-3.2.1/install-sh",
                "ext/fiddle/libffi-3.2.1/config.sub",
                "ext/fiddle/libffi-3.2.1/config.guess",
                "ext/fiddle/libffi-3.2.1/missing",
            ])
        ),
    }
)
