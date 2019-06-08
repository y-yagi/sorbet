#!/bin/bash

base_dir=$(dirname ${BASH_SOURCE[0]})

source "$base_dir/bundle-env"

exec "${BUNDLER_ROOT}/exe/bundler" "$@"
