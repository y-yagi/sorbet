#!/usr/bin/env bash

set -euo pipefail
shopt -s dotglob

# shellcheck disable=SC1090
source "gems/sorbet/test/snapshot/logging.sh"

# ----- Helper functions -----

wrap_verbose() {
  out_log="$(mktemp)"
  # shellcheck disable=SC2064
  trap "rm -f '$out_log'" EXIT

  if ! "$@" > "$out_log" 2>&1; then
    if [ -z "$VERBOSE" ]; then
      error "└─ '$*' failed. Re-run with --verbose for more."
    else
      cat "$out_log"
      error "└─ '$*' failed. See output above."
    fi
    exit 1
  fi
  if [ -n "$VERBOSE" ]; then
    cat "$out_log"
  fi
}

# ----- Environment setup -----

repo_root=$PWD

root_dir="$repo_root/gems/sorbet"

# the path to the ruby wrapper and bundle wrapper
PATH="$(dirname $repo_root/$1):$(dirname $repo_root/$2):$PATH"

# get bundler into the RUBYLIB
source "$2-env"

# test that ruby is working
ruby -e '1 + 1'

# the third argument is the location of the bundle vendor cache
vendor_cache=$repo_root/$(dirname $3)

# the fourth argument is the path to the test, relative to
# //gems/sorbet/test/snapshot
test_dir=$root_dir/test/snapshot/$4

is_partial=$(echo "$4" | grep "^partial/" || echo "")

VERBOSE=1

# ----- Stage the test sandbox directory -----

actual="$(mktemp -d)"

if [ -n "$VERBOSE" ]; then
  info "├─ PWD:       $PWD"
  info "├─ test_dir:  $test_dir"
  info "├─ actual:    $actual"
fi

srb="$root_dir/bin/srb"

export SRB_SORBET_EXE="$repo_root/main/sorbet"

# test that srb works
$srb --help &> /dev/null

if ! [ -d "$test_dir/src" ]; then
  error "└─ each test must have a src/ dirctory: $test_dir/src"
  exit 1
fi

if ! [ -f "$test_dir/src/Gemfile" ]; then
  error "├─ each test must have src/Gemfile: $test_dir/src/Gemfile"
  warn "└─ re-run with --update to create it."
  exit 1
fi

if ! [ -f "$test_dir/src/Gemfile.lock" ]; then
  error "├─ each test must have src/Gemfile.lock: $test_dir/src/Gemfile.lock"
  exit 1
fi

# TODO: make these files recordable
if [ -d "$test_dir/expected/sorbet/rbi/hidden-definitions" ]; then
  error "├─ hidden-definitions are not currently testable."

  warn "└─ please remove: $test_dir/expected/sorbet/rbi/hidden-definitions"
  exit 1
fi

cp -r "$test_dir/src"/* "$actual"


# ----- Run the test in the sandbox -----

(
  # Only cd because `srb init` needs to be run from the folder with a Gemfile,
  # not because this test driver needs to refer to files with relative paths.
  cd "$actual"

  export HOME=$actual
  export XDG_CACHE_HOME="$actual/.cache"
  export LC_CTYPE=en_US.UTF-8

  bundle install --verbose --local --path "$vendor_cache"

  # note: redirects stderr before the pipe
  if ! SRB_YES=1 "$srb" init 2> "$actual/err.log" | \
      sed -e 's/with [0-9]* modules and [0-9]* aliases/with X modules and Y aliases/' \
      > "$actual/out.log"; then
    error "├─ srb init failed."
    if [ -z "$VERBOSE" ]; then
      error "├─ stdout: $actual/out.log"
      error "├─ stderr: $actual/err.log"
      error "└─ (or re-run with --verbose)"
    else
      error "├─ stdout ($actual/out.log):"
      cat "$actual/out.log"
      error "├─ stderr ($actual/err.log):"
      cat "$actual/err.log"
      error "└─ (end stderr)"
    fi
    exit 1
  fi
)

# ----- Check out.log -----

if [ -z "$is_partial" ] || [ -f "$test_dir/expected/out.log" ]; then
  if ! diff -u "$test_dir/expected/out.log" "$actual/out.log"; then
    error "├─ expected out.log did not match actual out.log"
    error "└─ see output above."
    exit 1
  fi
fi

# ----- Check err.log -----

if [ -z "$is_partial" ] || [ -f "$test_dir/expected/err.log" ]; then
  if ! diff -u "$test_dir/expected/err.log" "$actual/err.log"; then
    error "├─ expected err.log did not match actual err.log"
    error "└─ see output above."
    exit 1
  fi
fi

# ----- Check sorbet/ -----

# FIXME: Removing hidden-definitions in actual to hide them from diff output.
rm -rf "$actual/sorbet/rbi/hidden-definitions"

diff_total() {
  if ! diff -ur "$test_dir/expected/sorbet" "$actual/sorbet"; then
    error "├─ expected sorbet/ folder did not match actual sorbet/ folder"
    error "└─ see output above. Run with --update to fix."
    exit 1
  fi
}

diff_partial() {
  set +e
  diff -ur "$test_dir/expected/sorbet" "$actual/sorbet" | \
    grep -vF "Only in $actual" \
    > "$actual/partial-diff.log"
  set -e

  # File exists and is non-empty
  if [ -s "$actual/partial-diff.log" ]; then
    cat "$actual/partial-diff.log"
    error "├─ expected sorbet/ folder did not match actual sorbet/ folder"
    error "└─ see output above."
    exit 1
  fi
}

if [ -z "$is_partial" ]; then
  diff_total
elif [ -d "$test_dir/expected/sorbet" ]; then
  diff_partial
else
  # It's fine for a partial test to not have an expected dir.
  # It means the test only cares about the exit code of srb init.
  true
fi

rm -rf "$actual"

success "└─ test passed."
