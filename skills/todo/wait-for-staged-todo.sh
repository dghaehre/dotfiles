#!/usr/bin/env bash
set -euo pipefail

# Block until the staged diff contains an added TODO or NOTE comment,
# then exit 0. Polls the git index file's mtime every 2 s; only re-checks
# the diff when the index actually changes.
#
# Resolves the index path via `git rev-parse --absolute-git-dir` so this
# works in both plain checkouts (index at `.git/index`) and linked
# worktrees (index at `<main>/.git/worktrees/<name>/index` — `.git` in
# the worktree is a file, not a directory).
#
# Two modes, controlled by the first argument:
#   --check-now : non-blocking status query. Exits 0 if a TODO/NOTE is
#                 staged right now, exits 1 if not. Never blocks.
#   (no arg)    : blocking watch. Polls the index file's mtime every 2 s
#                 and exits 0 the first time the staged diff contains a
#                 TODO or NOTE after a change. Runs until that happens
#                 (or until the harness times it out).

repo_root="$(git rev-parse --show-toplevel)"
git_dir="$(git -C "$repo_root" rev-parse --absolute-git-dir)"
index_file="$git_dir/index"

# Match an added diff line (`^\+`, not a `+++` file header) that contains
# TODO or NOTE as a whole word. Word-boundary matching means
# `TODO(refactor):`, `TODO fix this`, and `// TODO: foo` all fire, while
# identifiers like `TODO_COUNT` or `todoList` do not.
check() {
  git -C "$repo_root" diff --cached --unified=0 \
    | grep -Eq '^\+[^+].*\<(TODO|NOTE)\>'
}

get_mtime() {
  stat -f %m "$index_file" 2>/dev/null || echo 0
}

if [ "${1:-}" = "--check-now" ]; then
  if check; then exit 0; else exit 1; fi
fi

prev=$(get_mtime)
while sleep 2; do
  cur=$(get_mtime)
  if [ "$cur" != "$prev" ]; then
    prev=$cur
    if check; then
      exit 0
    fi
  fi
done
