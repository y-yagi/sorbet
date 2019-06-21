#!/bin/bash
set -eu

echo "--- autogen-subclasses ---"
main/sorbet --silence-dev-message --stop-after=resolver -p autogen-subclasses --autogen-subclasses-parent=Opus::DB::Model --autogen-subclasses-parent=Opus::DB::Migration --autogen-subclasses-ignore=/test /test/cli/autogen-subclasses/a.rb