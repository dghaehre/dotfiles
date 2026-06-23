#!/usr/bin/env bash
set -euo pipefail

# Block until a new TODO or NOTE comment appears in the working-copy
# revision @, then exit 0. At startup, the script captures the set of
# TODO/NOTE additions already in @'s diff as a baseline. It then polls
# `jj diff` every 2 s and only fires when a line containing TODO or NOTE
# appears in the current diff that was NOT in the baseline — i.e. only
# on edits made *during* the watch.
#
# Calling `jj diff` also snapshots the working copy on each poll, so no
# external file watcher is required.

repo_root="$(jj root)"

# Lines added in @'s diff that contain TODO or NOTE as a whole word.
# `^\+` excludes the `+++` file header. Sorted and de-duplicated so the
# output is suitable for `comm`.
get_todo_lines() {
  jj -R "$repo_root" diff --git \
    | { grep -E '^\+[^+].*\<(TODO|NOTE)\>' || true; } \
    | sort -u
}

baseline="$(get_todo_lines)"

while sleep 2; do
  current="$(get_todo_lines)"
  # New TODO/NOTE lines = present in current, absent from baseline.
  new_lines="$(comm -23 <(printf '%s\n' "$current") <(printf '%s\n' "$baseline"))"
  if [ -n "$new_lines" ]; then
    exit 0
  fi
done
