---
name: todo
description: Continuously watch for unstaged Git changes that introduce a TODO: or NOTE: comment. As soon as one appears, remove the comment from the working file, implement what it asks for, and wait for the next one. Loops until the user says to stop.
---

# Todo

Run as a continuous loop: wait for the user to save an unstaged hunk containing an added `TODO:` or `NOTE:` comment, immediately remove the comment from the working file, implement what it asks for, then wait again. `TODO:` and `NOTE:` are treated identically. The loop exits only when the user explicitly tells you to stop.

## Loop until told to stop

The watcher script has two modes:

- `--check-now` is a **non-blocking status query**. Run it foreground (no `run_in_background`); it returns within a second. Exit 0 means a TODO/NOTE is present in the unstaged diff right now; exit 1 means nothing to do.
- No flag is the **blocking watch**. It runs until the unstaged diff changes and contains a TODO/NOTE. Run it via the Bash tool with `run_in_background: true` and `timeout: 600000`; the harness notifies you when it returns. Do not poll, sleep, or do other work in the meantime.

Each iteration:

1. Status query:
   ```bash
   bash ~/.claude/skills/todo/wait-for-unstaged-todo.sh --check-now
   ```
2. If it exits 0, a TODO/NOTE is already in the unstaged diff — skip step 3 and go straight to "Clear the trigger".
3. If it exits 1, nothing is there yet — block:
   ```bash
   bash ~/.claude/skills/todo/wait-for-unstaged-todo.sh
   ```
   On exit 0, proceed to "Clear the trigger". On 10-minute timeout, just restart the loop at step 1.
4. After handling the trigger and implementing, return to step 1.
5. Exit the loop only when the user says so ("stop watching", "done", "stop the loop", etc.). When you exit, briefly confirm.

## Clear the trigger

As soon as the watcher fires, neutralize the TODO/NOTE in the working file *before* implementing, so it can't re-trigger the loop:

1. Read the unstaged diff to learn which files contain `TODO:`/`NOTE:` lines and what each says:
   ```bash
   git diff --unified=3
   ```
2. For each file with an unstaged TODO/NOTE: edit the working file to remove only the TODO/NOTE comment line(s). Leave all other content untouched.

After this step the working tree no longer contains the trigger, so the next watcher invocation only fires on a genuinely new edit.

## Implement each item

For every TODO/NOTE you just cleared:

1. Read the surrounding code to understand intent.
2. Make the smallest correct change in the working file.
3. **Do not stage anything.** Leave changes unstaged so the user can review the diff before staging it themselves.
4. Handle items one at a time and watch for conflicts.

## Validation

Run the smallest relevant validation for the files you changed. Prefer targeted tests, lint, or build commands over broad suites.

If validation cannot be run, say so and explain why.

## Guardrails

- Treat the comment text as intent, not as a full specification; confirm behavior from the code around it.
- Do not rewrite unrelated parts of the file just because you are already editing it.
- Do not touch existing TODO/NOTE comments outside the new unstaged additions unless they must change to complete an item.
- Do not run any state-changing Git commands. No `git add`, `git restore`, `git commit`, `git reset`, `git checkout`, `git stash`, `git rm`, or anything similar. The user manages the index and history themselves.
