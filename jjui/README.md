# Workspace shortcuts

In the revisions view, press `w` followed by:

- `l`: list names, working changes and paths (`*` marks the current workspace).
- `a`: create a workspace on a new child of the highlighted revision, with name
  and directory prompts. Defaults to a sibling such as `repo.feature`. Offers
  to switch after creation.
- `o`: open a workspace using jjui's picker (`/` filters).
- `g`: return to a selected workspace in the tmux pane that opened jjui. This
  requires that pane to be running Fish; jjui closes and Fish changes directory.
- `-`: toggle back to the previous workspace within this jjui session.
- `f`: forget a workspace, keeping its directory. Snapshot its edits first when
  its path is available; protect the current and `default` workspaces.
- `F`: forget a workspace and move its directory to macOS Trash, after showing
  the path and confirming. Refuses the current/default workspace, shared repo
  storage, and directories containing other registered workspaces. Requires
  Python 3 and `trash`. A Trash failure after forgetting is reported explicitly.
- `r`: rename the current workspace's jj name; its directory does not move.
- `s`: open a tmux window in the current workspace (or a temporary shell outside
  tmux).

Switching snapshots the outgoing workspace and runs `jj status` in the target,
using `snapshot.auto-update-stale = true` from the jj config. It resets the
displayed revset and selects the target's working change. It changes jjui's
workspace, not the original shell/editor behind a tmux popup. The `e` and `O`
file actions use absolute paths so they open files from the correct workspace.

When jjui is opened with the tmux `prefix` then `u` binding from a Fish prompt,
`g` offers a safe handoff back to that pane. jjui puts the selected path in a
tmux pane option, signals Fish, and Fish verifies that it is still a workspace
in the same repository before changing directory. The handoff is one-shot and
is cleared before validation. jjui can open from any pane; `g` reports an error
without changing anything unless the pane that opened it is currently Fish.

Stop processes using a workspace before trashing it. Tracked/unignored edits
are snapshotted first; ignored files are recoverable from Trash, not jj history.
Workspace switching does not reload repository-specific jjui configuration.

Configuration lives in `config.lua`; existing commands remain in `config.toml`.
Inspired by <https://github.com/idursun/jjui/discussions/552>.

## Verification

Run from the dotfiles repository (the tests require jj, LuaJIT and Python 3):

```sh
test_dir=$(mktemp -d /private/tmp/jjui-workspaces.XXXXXX)
export XDG_CONFIG_HOME="$test_dir/config"
export JJ_CONFIG="$PWD/jj/.config/jj/config.toml"
export JJUI_CONFIG_DIR="$PWD/jjui/.config/jjui"
unset TMUX
jj git init "$test_dir/main"
luajit jjui/tests/workspaces.lua "$JJUI_CONFIG_DIR" "$test_dir"
python3 -B jjui/tests/workspace_trash.py "$JJUI_CONFIG_DIR" "$test_dir"
```

These tests use temporary repositories and mock Trash; they do not remove real
workspaces or send anything to the user's Trash.
