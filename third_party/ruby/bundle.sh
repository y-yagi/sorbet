#!/bin/bash

base_dir=$(dirname ${BASH_SOURCE[0]})

if [ -d "$base_dir/bundle.runfiles" ]; then
  BUNDLER_ROOT="$base_dir/bundle.runfiles/%{workspace}/bundler"
else
  BUNDLER_ROOT="$base_dir"
fi

RUBYLIB="${BUNDLER_ROOT}/lib:${RUBYLIB:-}" exec "${BUNDLER_ROOT}/exe/bundler" "$@"
