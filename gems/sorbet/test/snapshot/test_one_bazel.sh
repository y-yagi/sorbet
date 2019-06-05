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

# the path to the ruby wrapper
PATH="$(dirname $repo_root/$1):$PATH"

# test that ruby is working
ruby -e '1 + 1'

# the second argument is the location of the Gemfile.lock_env.sh script
source "$2"

# the third argument is the path to the test, relative to
# //gems/sorbet/test/snapshot
test_dir=$root_dir/test/snapshot/$3

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
  if [ -z "$UPDATE" ]; then
    warn "└─ re-run with --update to create it."
    exit 1
  else
    warn "└─ creating empty Gemfile"
    touch "$test_dir/src/Gemfile"
  fi
fi

if ! [ -f "$test_dir/src/Gemfile.lock" ]; then
  error "├─ each test must have src/Gemfile.lock: $test_dir/src/Gemfile.lock"
  exit 1
fi

# TODO: make these files recordable
if [ -d "$test_dir/expected/sorbet/rbi/hidden-definitions" ]; then
  error "├─ hidden-definitions are not currently testable."

  if [ -z "$UPDATE" ]; then
    warn "└─ please remove: $test_dir/expected/sorbet/rbi/hidden-definitions"
    exit 1
  else
    warn "├─ removing: $test_dir/expected/sorbet/rbi/hidden-definitions"
    rm -rf "$test_dir/expected/sorbet/rbi/hidden-definitions"
  fi
fi

cp -r "$test_dir/src"/* "$actual"


# ----- Run the test in the sandbox -----

(
  # Only cd because `srb init` needs to be run from the folder with a Gemfile,
  # not because this test driver needs to refer to files with relative paths.
  cd "$actual"

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

    if [ -z "$UPDATE" ]; then
      error "└─ see output above."
      exit 1
    else
      warn "└─ updating expected/out.log"
      mkdir -p "$test_dir/expected"
      cp "$actual/out.log" "$test_dir/expected/out.log"
    fi
  fi
fi

# ----- Check err.log -----

if [ -z "$is_partial" ] || [ -f "$test_dir/expected/err.log" ]; then
  if ! diff -u "$test_dir/expected/err.log" "$actual/err.log"; then
    error "├─ expected err.log did not match actual err.log"

    if [ -z "$UPDATE" ]; then
      error "└─ see output above."
      exit 1
    else
      warn "└─ updating expected/err.log"
      cp "$actual/err.log" "$test_dir/expected/err.log"
    fi
  fi
fi

# ----- Check sorbet/ -----

# FIXME: Removing hidden-definitions in actual to hide them from diff output.
rm -rf "$actual/sorbet/rbi/hidden-definitions"

diff_total() {
  if ! diff -ur "$test_dir/expected/sorbet" "$actual/sorbet"; then
    error "├─ expected sorbet/ folder did not match actual sorbet/ folder"

    if [ -z "$UPDATE" ]; then
      error "└─ see output above. Run with --update to fix."
      exit 1
    else
      warn "├─ updating expected/sorbet (total):"
      rm -rf "$test_dir/expected/sorbet"
      cp -r "$actual/sorbet" "$test_dir/expected"
    fi
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

    if [ -z "$UPDATE" ]; then
      error "└─ see output above."
      exit 1
    else
      warn "├─ updating expected/sorbet (partial):"

      find "$test_dir/expected/sorbet" -print0 | while IFS= read -r -d '' expected_path; do
        path_suffix="${expected_path#$test_dir/expected/sorbet}"
        actual_path="$actual/sorbet$path_suffix"

        # Only ever update existing files, never grow this partial snapshot.
        if [ -d "$expected_path" ]; then
          if ! [ -d "$actual_path" ]; then
            rm -rfv "$expected_path"
          fi
        else
          if [ -f "$actual_path" ]; then
            cp -v "$actual_path" "$expected_path"
          else
            rm -fv "$expected_path"
          fi
        fi
      done
    fi
  fi
}

if [ -z "$is_partial" ]; then
  diff_total
elif [ -d "$test_dir/expected/sorbet" ]; then
  diff_partial
elif [ -n "$UPDATE" ]; then
  warn "├─ Treating empty partial test as total for the sake of updating."
  warn "├─ Feel free to delete files in this snapshot that you don't want."
  diff_total
else
  # It's fine for a partial test to not have an expected dir.
  # It means the test only cares about the exit code of srb init.
  true
fi

rm -rf "$actual"

success "└─ test passed."
