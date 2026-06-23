#!/usr/bin/env bash
set -euo pipefail

# Block until the unstaged working-tree diff contains an added TODO or
# NOTE comment, then exit 0. Polls a hash of `git diff` output every 2 s
# and only re-evaluates the match when the diff actually changes.
#
# Two modes, controlled by the first argument:
#   --check-now : non-blocking status query. Exits 0 if a TODO/NOTE is
#                 present in the unstaged diff right now, exits 1 if not.
#                 Never blocks.
#   (no arg)    : blocking watch. Polls the unstaged diff every 2 s and
#                 exits 0 the first time it changes and contains a TODO
#                 or NOTE. Runs until that happens (or until the harness
#                 times it out).

repo_root="$(git rev-parse --show-toplevel)"

# Match an added diff line (`^\+`, not a `+++` file header) that contains
# TODO or NOTE as a whole word. Word-boundary matching means
# `TODO(refactor):`, `TODO fix this`, and `// TODO: foo` all fire, while
# identifiers like `TODO_COUNT` or `todoList` do not.
check() {
  git -C "$repo_root" diff --unified=0 \
    | grep -Eq '^\+[^+].*\<(TODO|NOTE)\>'
}

get_diff_hash() {
  git -C "$repo_root" diff | shasum | awk '{print $1}'
}

if [ "${1:-}" = "--check-now" ]; then
  if check; then exit 0; else exit 1; fi
fi

prev=$(get_diff_hash)
while sleep 2; do
  cur=$(get_diff_hash)
  if [ "$cur" != "$prev" ]; then
    prev=$cur
    if check; then
      exit 0
    fi
  fi
done
