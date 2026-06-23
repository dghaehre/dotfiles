---
name: jj-todo
description: Continuously watch a jj-managed repository for new TODO: or NOTE: comments added to the working copy (@). As soon as one appears, remove the comment from the working file, implement what it asks for, and wait for the next one. Loops until the user says to stop.
---

# jj-todo

Run as a continuous loop in a **jj-managed repository**: wait for the user to add a *new* `TODO:` or `NOTE:` comment to a file in the working copy (the `@` revision), immediately remove the comment from the working file, implement what it asks for, then wait again. `TODO:` and `NOTE:` are treated identically. The loop exits only when the user explicitly tells you to stop.

This is the jj counterpart to the git-based `todo` skill. Use this one when the repo is managed by jj (a `.jj` directory at the repo root, or `jj log` works). For plain-git repos use `todo` instead.

**Pre-existing TODO/NOTE comments already in `@` when the watcher starts are ignored.** Only new additions made during the watch trigger the loop. This matters when the user is amending a non-empty `@` that already contains TODO lines.

## Loop until told to stop

The watcher script blocks until a new TODO/NOTE addition appears in `@`. Run it via the Bash tool with `run_in_background: true` and `timeout: 600000`; the harness notifies you when it returns. Do not poll, sleep, or do other work in the meantime.

Each iteration:

1. Block on the watcher:
   ```bash
   bash ~/.claude/skills/jj-todo/wait-for-jj-todo.sh
   ```
   On exit 0, proceed to "Clear the trigger". On 10-minute timeout, just restart the loop.
2. After handling the trigger and implementing, return to step 1.
3. Exit the loop only when the user says so ("stop watching", "done", "stop the loop", etc.). When you exit, briefly confirm.

## Clear the trigger

As soon as the watcher fires, neutralize the new TODO/NOTE in the working file *before* implementing, so it can't re-trigger the loop:

1. Read @'s diff to learn which files contain `TODO:`/`NOTE:` lines and what each says:
   ```bash
   jj diff --git
   ```
2. For each file with a TODO/NOTE you intend to act on, edit the working file to remove only that comment line. Leave all other content untouched.
3. If `@` contains TODO/NOTE lines that were present before the watcher started, leave them alone — they're not yours to clear. The watcher won't fire on them again because each fresh watcher run captures its own baseline.

## Implement each item

For every TODO/NOTE you just cleared:

1. Read the surrounding code to understand intent.
2. Make the smallest correct change in the working file.
3. **Do not split, squash, describe, abandon, or move the change.** Leave the edits as part of `@` so the user can review and commit/move them themselves.
4. Handle items one at a time and watch for conflicts.

## Validation

Run the smallest relevant validation for the files you changed. Prefer targeted tests, lint, or build commands over broad suites.

If validation cannot be run, say so and explain why.

## Guardrails

- Treat the comment text as intent, not as a full specification; confirm behavior from the code around it.
- Do not rewrite unrelated parts of the file just because you are already editing it.
- Do not touch existing TODO/NOTE comments outside the new additions unless they must change to complete an item.
- Do not run any state-changing jj commands. No `jj new`, `jj commit`, `jj squash`, `jj describe`, `jj split`, `jj abandon`, `jj rebase`, `jj restore`, `jj bookmark`, `jj git push`, or anything similar. The user manages revisions, bookmarks, and history themselves.
