#!/bin/bash

set -euo pipefail

cd source

echo "Configuring ruby"
./configure --prefix=%{ruby_prefix} --disable-install-doc

echo "Building ruby"
make

echo "Installing ruby"
make install

# setup the ruby env
source "%{ruby_prefix}/ruby_env.sh"

echo "Installing bundler"
gem install bundler
