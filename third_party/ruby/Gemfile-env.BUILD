
genrule(
    name = "env_file",
    outs = [ "Gemfile.lock-env.sh" ],
    cmd = """
cat >> $(location Gemfile.lock-env.sh) <<EOF
#!/bin/bash

export RUBYLIB="%{ruby_lib}:\$$RUBYLIB"
EOF
    """,
)

sh_library(
    name = "Gemfile.lock-env",
    data = [ %{env_deps} ],
    srcs = [ "Gemfile.lock-env.sh" ],
    visibility = ["//visibility:public"],
)
