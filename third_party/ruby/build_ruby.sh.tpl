#!/bin/bash

set -euo pipefail

ruby_prefix=$(pwd)

cd "external/%{workspace_name}/source"

echo "Configuring ruby"
./configure --prefix=$ruby_prefix --disable-install-doc

echo "Building ruby"
make

echo "Installing ruby"
make install

echo "Installing bundler"
gem install bundler
