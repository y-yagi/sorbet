#!/bin/bash

set -euo pipefail

pushd %{rbenv_path}

src/configure

make -C src

popd
