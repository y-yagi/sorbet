
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

cc_library(
    name = "libminiruby",
    hdrs = glob([ "include/**/*.h" ]),
)


cc_binary(
    name = "miniruby",

    srcs = [
        "main.c",
        "dmydln.c",
        "miniinit.c",
        "dmyext.c",
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

    deps = [ "miniruby_private_headers" ],

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


filegroup(
    name = "ruby_lib",
    srcs = glob(["lib/**/*.rb"]),
    visibility = ["//visibility:public"],
)


genrule(
    name = "ruby_script",
    outs = [ "ruby" ],
    cmd = """
cat >> $(location ruby) <<EOF
#!/bin/bash

set -euo pipefai

export RUBYLIB="external/ruby_2_4_3/lib:\$$RUBYLIB"

exec external/ruby_2_4_3/miniruby "\$$@"
EOF
    """,
)


sh_binary(
    name = "ruby_bin",
    data = [ ":miniruby", ":ruby_lib" ],
    srcs = [ "ruby" ],
    visibility = ["//visibility:public"],
)
