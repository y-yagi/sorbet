#!/bin/bash

base_dir=$(dirname ${BASH_SOURCE[0]})

source "$base_dir/bundle-env"

BUNDLER_BIN=$(rlocation %{workspace}/%{bundler}/%{site_bin})

exec "${BUNDLER_BIN}/bundler" "$@"
