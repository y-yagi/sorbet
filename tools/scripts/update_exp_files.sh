#!/bin/bash
set -e

COMMAND_FILE=$(mktemp)
trap 'rm -f "$COMMAND_FILE"' EXIT

passes=(parse-tree parse-tree-json ast ast-raw dsl-tree dsl-tree-raw symbol-table symbol-table-raw name-tree name-tree-raw resolve-tree resolve-tree-raw cfg cfg-json flattened-tree flattened-tree-raw autogen document-symbols)

bazel build \
  //gems/sorbet/test/snapshot:update \
  //test/cli:update //test/lsp:update //main:sorbet \
  //test:print_document_symbols -c opt "$@"

# shellcheck disable=SC2207
rb_src=(
    $(find test/testdata -name '*.rb' | sort)
)

basename=
srcs=()

for this_src in "${rb_src[@]}" DUMMY; do
    this_base=${this_src%__*}
    if [ "$this_base" = "$basename" ]; then
        srcs=("${srcs[@]}" "$this_src")
        continue
    fi

    if [ "$basename" ]; then
        for pass in "${passes[@]}" ; do
            candidate="$basename.$pass.exp"
            args=()
            if [ "$pass" = "autogen" ]; then
                args=("--stop-after=namer --skip-dsl-passes")
            fi
            if [ -e "$candidate" ]; then
                if [ "$pass" = "document-symbols" ]; then
                    echo bazel-bin/test/print_document_symbols "${srcs[@]}" \> "$candidate" 2\>/dev/null >> "$COMMAND_FILE"
                else
                    echo bazel-bin/main/sorbet --silence-dev-message  --suppress-non-critical --censor-raw-locs-within-payload --print "$pass" --max-threads 0 "${args[@]}" "${srcs[@]}" \> "$candidate" 2\>/dev/null >> "$COMMAND_FILE"
                fi
            fi
        done
    fi

    basename="$this_base"
    srcs=("$this_src")
done

parallel --joblog - < "$COMMAND_FILE"

bazel test \
  //gems/sorbet/test/snapshot:update \
  //test/cli:update //test/lsp:update -c opt "$@"
