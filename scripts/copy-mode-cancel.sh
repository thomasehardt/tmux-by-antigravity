#!/usr/bin/env bash
# copy-mode-cancel.sh <pane_id>
#
# Called via tmux `run-shell -b` after a copy operation. Waits
# COPY_MODE_TIMEOUT seconds then exits copy mode on the given pane —
# but only if it is still in copy mode (so manual Escape/q is unaffected).

PANE_ID="${1:-}"
LOG="$HOME/.tmux/logs/copy-mode-cancel-debug.log"
mkdir -p "$(dirname "$LOG")"

echo "[$(date '+%T')] START pane='$PANE_ID' TMUX='$TMUX'" >> "$LOG"

[ -z "$PANE_ID" ] && { echo "[$(date '+%T')] ABORT: no pane_id" >> "$LOG"; exit 0; }

# Read the timeout from the tmux global environment; fall back to 3 s.
TIMEOUT_RAW="$(tmux show-environment -g COPY_MODE_TIMEOUT 2>&1)"
TIMEOUT="$(echo "$TIMEOUT_RAW" | cut -d= -f2)"
TIMEOUT="${TIMEOUT:-3}"

echo "[$(date '+%T')] timeout_raw='$TIMEOUT_RAW' timeout='$TIMEOUT'" >> "$LOG"

sleep "$TIMEOUT"

IN_MODE="$(tmux display-message -p -t "$PANE_ID" '#{pane_in_mode}' 2>&1)"
echo "[$(date '+%T')] in_mode='$IN_MODE'" >> "$LOG"

if echo "$IN_MODE" | grep -q '^1$'; then
  RESULT="$(tmux send-keys -t "$PANE_ID" -X cancel 2>&1)"
  echo "[$(date '+%T')] cancel result='$RESULT'" >> "$LOG"
else
  echo "[$(date '+%T')] SKIP: not in copy mode (or pane gone)" >> "$LOG"
fi

echo "[$(date '+%T')] DONE" >> "$LOG"
