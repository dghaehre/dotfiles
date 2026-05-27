---
name: todo
description: Continuously watch for staged Git changes that introduce a TODO: or NOTE: comment. As soon as one appears, remove the comment from the index, implement what it asks for, stage the implementation, and wait for the next one. Loops until the user says to stop.
---

# Todo

Run as a continuous loop: wait for the user to stage a hunk containing an added `TODO:` or `NOTE:` comment, immediately clear the comment from the index, implement what it asks for, stage the implementation, then wait again. `TODO:` and `NOTE:` are treated identically. The loop exits only when the user explicitly tells you to stop.

## Loop until told to stop

The watcher script has two modes:

- `--check-now` is a **non-blocking status query**. Run it foreground (no `run_in_background`); it returns within a second. Exit 0 means a TODO/NOTE is staged right now; exit 1 means nothing to do.
- No flag is the **blocking watch**. It runs until a fresh staging event introduces a TODO/NOTE. Run it via the Bash tool with `run_in_background: true` and `timeout: 600000`; the harness notifies you when it returns. Do not poll, sleep, or do other work in the meantime.

Each iteration:

1. Status query:
   ```bash
   bash ~/.claude/skills/todo/wait-for-staged-todo.sh --check-now
   ```
2. If it exits 0, a TODO/NOTE is already staged — skip step 3 and go straight to "Clear the trigger".
3. If it exits 1, nothing is staged yet — block:
   ```bash
   bash ~/.claude/skills/todo/wait-for-staged-todo.sh
   ```
   On exit 0, proceed to "Clear the trigger". On 10-minute timeout, just restart the loop at step 1.
4. After handling the trigger and implementing, return to step 1.
5. Exit the loop only when the user says so ("stop watching", "done", "stop the loop", etc.). When you exit, briefly confirm.

## Clear the trigger

As soon as the watcher fires, neutralize the TODO/NOTE in the index *before* implementing, so it can't re-trigger the loop:

1. Read the staged diff to learn which files contain `TODO:`/`NOTE:` lines and what each says:
   ```bash
   git diff --cached --unified=3
   ```
2. For each file with a staged TODO/NOTE:
   a. Check the file for unstaged changes: `git diff -- <path>`. If it has unstaged modifications, **skip this item** and tell the user — do not silently stage their work-in-progress. The TODO will be picked up on a later iteration once their tree is clean for that file.
   b. Edit the working file to remove only the TODO/NOTE comment line(s). Leave all other content untouched.
   c. Stage the cleared file:
      ```bash
      git add <path>
      ```

After this step the index no longer contains the trigger, so the next watcher invocation only fires on a genuinely new staging event.

## Implement each item

For every TODO/NOTE you just cleared:

1. Read the surrounding code to understand intent.
2. Make the smallest correct change in the working file.
3. **Do not stage the implementation.** Leave it as an unstaged change so the user can review the diff before staging it themselves.
4. Handle items one at a time and watch for conflicts.

## Validation

Run the smallest relevant validation for the files you changed. Prefer targeted tests, lint, or build commands over broad suites.

If validation cannot be run, say so and explain why.

## Guardrails

- Treat the comment text as intent, not as a full specification; confirm behavior from the code around it.
- Do not rewrite unrelated parts of the file just because you are already editing it.
- Do not touch existing TODO/NOTE comments outside the staged additions unless they must change to complete a staged item.
- The **only** Git operation you may run is `git add <specific path>` to clear a TODO/NOTE comment line from the index (step 2c of "Clear the trigger"). Nothing else.
  - Never `git add .`, `git add -A`, `git add -u`, or any pattern/glob.
  - Never `git add` your own implementation work — the user reviews and stages that themselves.
  - Never `git restore`, `git commit`, `git reset`, `git checkout`, `git stash`, `git rm`, or any other state-changing Git command.
- If a TODO/NOTE file has unstaged changes when the watcher fires, skip it and warn the user; do not stage unrelated work-in-progress.
