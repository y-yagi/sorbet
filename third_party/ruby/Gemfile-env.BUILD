
genrule(
    name = "generate-Gemfile.lock-env.sh",
    outs = [ "Gemfile.lock-env.sh" ],
    cmd = """
    cat > $(location Gemfile.lock-env.sh) <<EOF
#!/bin/bash

base_dir="\$$(dirname \$${BASH_SOURCE[0]})"

echo '%{env_deps}'

if [ -d "\$$base_dir/Gemfile.lock-env.runfiles" ]; then
  export RUBYLIB="%{ruby_lib}:\$${RUBYLIB:-}"
else
  export RUBYLIB="%{ruby_lib}:\$${RUBYLIB:-}"
fi
EOF
"""
)

sh_binary(
    name = "Gemfile.lock-env",
    data = [ %{env_deps} ],
    srcs = [ "Gemfile.lock-env.sh" ],
    visibility = ["//visibility:public"],
)
