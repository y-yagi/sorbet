
genrule(
    name = "generate-Gemfile.lock-env.sh",
    outs = [ "Gemfile.lock-env.sh" ],
    cmd = """
    cat > $(location Gemfile.lock-env.sh) <<EOF
#!/bin/bash

# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "\$${RUNFILES_DIR:-/dev/null}/\$$f" 2>/dev/null || \
  source "\$$(grep -sm1 "^\$$f " "\$${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "\$$0.runfiles/\$$f" 2>/dev/null || \
  source "\$$(grep -sm1 "^\$$f " "\$$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "\$$(grep -sm1 "^\$$f " "\$$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find \$$f"; exit 1; }; f=; set -e

base_dir="\$$(dirname \$${BASH_SOURCE[0]})"

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
    deps = [ "@bazel_tools//tools/bash/runfiles" ],
    visibility = ["//visibility:public"],
)
