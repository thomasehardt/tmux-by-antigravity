#!/usr/bin/env bash
# Record Claude's state on its tmux window so the tab bar can show which
# session needs you. The tab-bar side lives in tmux.conf (@claude_badge).
#
# Usage: tmux-status.sh <working|waiting|done|error|clear>
#
# The state is a window option, @claude_state, on the window that holds the
# pane Claude runs in ($TMUX_PANE, inherited from the shell that started it).
# Outside tmux this is a no-op.
#
# Exits 0 no matter what: a status marker must never fail or slow a hook.

set -u

state="${1:-}"
[[ -n "${TMUX_PANE:-}" ]] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

# Notification also fires for "idle_prompt", Claude's reminder that it has
# been sitting at the prompt. That is not a new request for you, so it must
# not turn "done" or "error" into "waiting".
if [[ "$state" == "waiting" && ! -t 0 ]]; then
  payload="$(cat)"
  case "$payload" in
    *'"notification_type":"idle_prompt"'* | *'"notification_type": "idle_prompt"'*) exit 0 ;;
  esac
fi

case "$state" in
  working | waiting | done | error)
    tmux set-option -w -t "$TMUX_PANE" @claude_state "$state" >/dev/null 2>&1
    ;;
  clear)
    tmux set-option -wu -t "$TMUX_PANE" @claude_state >/dev/null 2>&1
    ;;
esac

exit 0
