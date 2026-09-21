# jjui writes a selected workspace to this pane option, then signals Fish.
# This handler only changes the current Fish process, never injects a command
# into the pane. It is registered on startup by Fish's conf.d loading.
function __jjui_workspace_handoff --on-signal USR1
    if not set -q TMUX_PANE; or not command -sq tmux
        return
    end

    set -l target
    if not set target (command tmux show-options -p -v -t "$TMUX_PANE" @jjui_workspace_handoff 2>/dev/null)
        return
    end
    command tmux set-option -p -u -t "$TMUX_PANE" @jjui_workspace_handoff

    if test (count $target) -ne 1; or not test -d "$target"; or not test -e "$target/.jj"
        printf 'jjui: ignored an invalid workspace handoff\n' >&2
        return
    end

    set -l roots
    if not set roots (command jj workspace list -T 'self.root() ++ "\\n"' 2>/dev/null)
        printf 'jjui: could not validate the workspace handoff\n' >&2
        return
    end
    if not contains -- "$target" $roots
        printf 'jjui: ignored a workspace outside this repository\n' >&2
        return
    end

    cd -- "$target"
    if status is-interactive
        commandline -f repaint
    end
end
