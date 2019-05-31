# vim: ft=bzl sw=4 ts=4 et

# caveats ######################################################################

# Hard-coded files
# * config.h
# * probes.h

# Templated files
# * verconf.h is just a templated version of what ruby produces

# Build assumptions
# * configure is not run


# shared headers ###############################################################

cc_library(
    name = "ruby_headers",
    srcs = glob([ "include/**/*.h" ]),
    includes = [ "include" ],
)


# miniruby #####################################################################

cc_library(
    name = "miniruby_private_headers",
    hdrs = [
        "lex.c",
        "thread_pthread.c",
        "thread_sync.c",
        "id.c",
        "eval_error.c",
        "vsnprintf.c",
        "vm_insnhelper.c",
        "vm_args.c",
        "vm_exec.c",
        "vm_eval.c",
        "vm_method.c",
        "id_table.c",
        "eval_jump.c",
        "siphash.c",
    ],
)

cc_binary(
    name = "bin/miniruby",

    data = [ ":ruby_lib" ],

    srcs = [
        "main.c",
        "dmydln.c",
        "dmyext.c",
        "miniinit.c",
        "miniprelude.c",
        "array.c",
        "bignum.c",
        "class.c",
        "compar.c",
        "compile.c",
        "complex.c",
        "cont.c",
        "debug.c",
        "dir.c",
        "dln_find.c",
        "encoding.c",
        "enum.c",
        "enumerator.c",
        "error.c",
        "eval.c",
        "file.c",
        "gc.c",
        "hash.c",
        "inits.c",
        "io.c",
        "iseq.c",
        "load.c",
        "marshal.c",
        "math.c",
        "node.c",
        "numeric.c",
        "object.c",
        "pack.c",
        "parse.c",
        "proc.c",
        "process.c",
        "random.c",
        "range.c",
        "rational.c",
        "re.c",
        "regcomp.c",
        "regenc.c",
        "regerror.c",
        "regexec.c",
        "regparse.c",
        "regsyntax.c",
        "ruby.c",
        "safe.c",
        "signal.c",
        "sprintf.c",
        "st.c",
        "strftime.c",
        "string.c",
        "struct.c",
        "symbol.c",
        "thread.c",
        "time.c",
        "transcode.c",
        "util.c",
        "variable.c",
        "version.c",
        "vm.c",
        "vm_backtrace.c",
        "vm_dump.c",
        "vm_trace.c",
        "enc/ascii.c",
        "enc/us_ascii.c",
        "enc/unicode.c",
        "enc/utf_8.c",
        "enc/trans/newline.c",
        "missing/explicit_bzero.c",
        "missing/setproctitle.c",
    ] + glob([
        "*.h",
        "*.inc",
        "include/**/*.h",
        "enc/**/*.h",
        "ccan/**/*.h",
    ]),

    deps = [
        ":miniruby_private_headers",
        ":ruby_headers",
    ],

    copts = [
        "-DRUBY_EXPORT",
        "-D_XOPEN_SOURCE",
        "-Wno-constant-logical-operand",
        "-Wno-parentheses",
        "-D_DARWIN_C_SOURCE",
        "-D_REENTRANT",

        # TODO: is this really necessary?
        "-Wno-string-plus-int",
    ],

    linkopts = [
        "-framework",
        "Foundation",
        "-lpthread",
    ],

    includes = [ "include", "enc/unicode/9.0.0" ],

    visibility = ["//visibility:public"],
)

# full ruby ####################################################################

genrule(
    name = "prelude",
    srcs = [
        ":bin/miniruby",
        ":ruby_lib",
        "lib/irb.rb",
        "tool/generic_erb.rb",
        "tool/vpath.rb",
        "template/prelude.c.tmpl",
        "prelude.rb",
        "enc/prelude.rb",
        "gem_prelude.rb",
    ],
    outs = [ "prelude.c" ],
    cmd = """
# -----------------
$(location bin/miniruby) \
    -I. \
    -I$$(dirname $(location lib/irb.rb)) \
    -I$$(dirname $(location prelude.rb)) \
    $(location tool/generic_erb.rb) \
    -c -o $(location prelude.c) \
    $(location template/prelude.c.tmpl) \
    $(location prelude.rb) \
    $(location enc/prelude.rb) \
    $(location gem_prelude.rb)
""",
)

genrule(
    name = "verconf",
    srcs = [ ":bin/miniruby" ],
    outs = [ "verconf.h" ],
    cmd = """
prefix=$$(dirname $(location bin/miniruby))
cat > $(location verconf.h) <<EOF
#define RUBY_BASE_NAME                  "ruby"
#define RUBY_VERSION_NAME               RUBY_BASE_NAME"-"RUBY_LIB_VERSION
#define RUBY_LIB_VERSION_STYLE          3    /* full */
#define RUBY_EXEC_PREFIX                "$$prefix"
#define RUBY_LIB_PREFIX                 RUBY_EXEC_PREFIX"/lib/ruby"
#define RUBY_ARCH_PREFIX_FOR(arch)      RUBY_LIB_PREFIX"/"arch
#define RUBY_SITEARCH_PREFIX_FOR(arch)  RUBY_LIB_PREFIX"/"arch
#define RUBY_LIB                        RUBY_LIB_PREFIX"/"RUBY_LIB_VERSION
#define RUBY_ARCH_LIB_FOR(arch)         RUBY_LIB"/"arch
#define RUBY_SITE_LIB                   RUBY_LIB_PREFIX"/site_ruby"
#define RUBY_SITE_ARCH_LIB_FOR(arch)    RUBY_SITE_LIB2"/"arch
#define RUBY_VENDOR_LIB                 RUBY_LIB_PREFIX"/vendor_ruby"
#define RUBY_VENDOR_ARCH_LIB_FOR(arch)  RUBY_VENDOR_LIB2"/"arch
EOF
"""
)

cc_binary(
    name = "bin/ruby",

    data = [ ":ruby_lib" ],

    srcs = [
        "prelude.c",
        "verconf.h",

        "main.c",
        "ext/extinit.c",
        "dln.c",
        "localeinit.c",
        "loadpath.c",
        "dmyenc.c",
        "array.c",
        "bignum.c",
        "class.c",
        "compar.c",
        "compile.c",
        "complex.c",
        "cont.c",
        "debug.c",
        "dir.c",
        "dln_find.c",
        "encoding.c",
        "enum.c",
        "enumerator.c",
        "error.c",
        "eval.c",
        "file.c",
        "gc.c",
        "hash.c",
        "inits.c",
        "io.c",
        "iseq.c",
        "load.c",
        "marshal.c",
        "math.c",
        "node.c",
        "numeric.c",
        "object.c",
        "pack.c",
        "parse.c",
        "proc.c",
        "process.c",
        "random.c",
        "range.c",
        "rational.c",
        "re.c",
        "regcomp.c",
        "regenc.c",
        "regerror.c",
        "regexec.c",
        "regparse.c",
        "regsyntax.c",
        "ruby.c",
        "safe.c",
        "signal.c",
        "sprintf.c",
        "st.c",
        "strftime.c",
        "string.c",
        "struct.c",
        "symbol.c",
        "thread.c",
        "time.c",
        "transcode.c",
        "util.c",
        "variable.c",
        "version.c",
        "vm.c",
        "vm_backtrace.c",
        "vm_dump.c",
        "vm_trace.c",
        "enc/ascii.c",
        "enc/us_ascii.c",
        "enc/unicode.c",
        "enc/utf_8.c",
        "enc/trans/newline.c",
        "missing/explicit_bzero.c",
        "missing/setproctitle.c",
    ] + glob([
        "*.h",
        "*.inc",
        "include/**/*.h",
        "enc/**/*.h",
        "ccan/**/*.h",
    ]),

    deps = [
        ":miniruby_private_headers",
        ":ruby_headers",
        ":ext/pathname",
    ],

    copts = [
        "-DRUBY_EXPORT",
        "-D_XOPEN_SOURCE",
        "-Wno-constant-logical-operand",
        "-Wno-parentheses",
        "-D_DARWIN_C_SOURCE",
        "-D_REENTRANT",

        # TODO: is this really necessary?
        "-Wno-string-plus-int",
    ],

    linkopts = [
        "-framework",
        "Foundation",
        "-lpthread",
    ],

    includes = [ "include", "enc/unicode/9.0.0" ],

    visibility = ["//visibility:public"],
)
# extensions ###################################################################

# NOTE: update `Init_ext` below if you add a new extension.
genrule(
    name = "ext/extinit",
    outs = [ "ext/extinit.c" ],
    cmd = """
cat > $(location ext/extinit.c) <<EOF
#include "ruby/ruby.h"

#define init(func, name) {      \
    extern void func(void);     \
    ruby_init_ext(name, func);  \
}

void ruby_init_ext(const char *name, void (*init)(void));

void Init_ext(void)
{
    init(Init_pathname, "pathname.so");
}
EOF
""",
)

cc_library(
    name = "ext/pathname",
    srcs = [ "ext/pathname/pathname.c" ],
    deps = [ ":ruby_headers" ],
    linkstatic = 1,
)

genrule(
    name = "ruby_ext/pathname",
    srcs = [ "ext/pathname/lib/pathname.rb" ],
    outs = [ "lib/pathname.rb" ],
    cmd = "cp $(location ext/pathname/lib/pathname.rb) $(location lib/pathname.rb)",
)


# core library #################################################################

filegroup(
    name = "ruby_lib",
    srcs = [
        "lib/pathname.rb",
    ] + glob([ "lib/**/*.rb" ]),
    visibility = ["//visibility:public"],
)


# wrapper script ###############################################################

genrule(
    name = "ruby_script",
    outs = [ "ruby.sh" ],
    cmd = """
cat >> $(location ruby.sh) <<EOF
#!/bin/bash

set -euo pipefail

base_dir="\$$(dirname \$$0)"
if [ ! -d "\$$base_dir/lib" ]; then

  # we were invoked by bazel run
  if [ -d external ]; then
    base_dir=external/ruby_2_4_3
  else
    echo "Unable to determine location of runtime dependencies!"
    exit 1
  fi

fi

export RUBYLIB="\$$base_dir/lib:\$${RUBYLIB:-}"

exec "\$$base_dir/miniruby" "\$$@"
EOF
    """,
)

sh_binary(
    name = "ruby",
    data = [ ":bin/miniruby", ":ruby_lib" ],
    srcs = [ "ruby.sh" ],
    visibility = ["//visibility:public"],
)
