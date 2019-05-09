#!/bin/sh
# Test that cfg-proto output is parseable as a MultiCFG using external tools
main/sorbet --no-error-count --silence-dev-message -p cfg-proto -e 'def foo; end; def bar; end' | \
  external/com_google_protobuf/protoc --decode com.stripe.rubytyper.MultiCFG proto/CFG.proto | \
  grep -A10 '^cfg {' | grep '^[[:space:]]*name:'
