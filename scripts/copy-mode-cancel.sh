#!/usr/bin/env bash
# copy-mode-cancel.sh <pane_id>
#
# Called via tmux `run-shell -b` after a copy operation. Waits
# COPY_MODE_TIMEOUT seconds then exits copy mode on the given pane —
# but only if it is still in copy mode (so manual Escape/q is unaffected).

PANE_ID="${1:-}"
[ -z "$PANE_ID" ] && exit 0

# Read the timeout from the tmux global environment; fall back to 3 s.
TIMEOUT="$(tmux show-environment -g COPY_MODE_TIMEOUT 2>/dev/null | cut -d= -f2)"
TIMEOUT="${TIMEOUT:-3}"

sleep "$TIMEOUT"

if tmux display-message -p -t "$PANE_ID" '#{pane_in_mode}' 2>/dev/null | grep -q '^1$'; then
  tmux send-keys -t "$PANE_ID" q 2>/dev/null || true
fi
