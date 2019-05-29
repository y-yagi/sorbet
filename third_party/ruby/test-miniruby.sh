#!/bin/bash

set -euo pipefail

miniruby=$1

echo '$:.push("/Users/trevor/.rbenv/versions/2.4.5/lib/ruby/2.4.0"); require "set"' | $miniruby

echo 'require "set"' | RUBYLIB=/Users/trevor/.rbenv/versions/2.4.5/lib/ruby/2.4.0 $miniruby
echo 'puts "Hello, world!\n"' | $miniruby
echo 'puts (1 + 1)' | $miniruby
