#!/usr/bin/env bash
# copy-and-timed-exit.sh
# Pipe stdin to the system clipboard, then exit copy mode after a short delay.
#
# Usage (from tmux bind):
#   bind -T copy-mode-vi y send -X copy-pipe "~/.tmux/scripts/copy-and-timed-exit.sh"
#
# COPY_MODE_TIMEOUT (seconds) can be overridden in ~/.tmux.conf.local:
#   set-environment -g COPY_MODE_TIMEOUT 3
set -euo pipefail

TIMEOUT="${COPY_MODE_TIMEOUT:-3}"
PANE_ID="${TMUX_PANE:-}"

# Read the selected text from stdin BEFORE handing off to clipboard.sh.
# We can't just pipe directly to clipboard.sh because it uses `exec`, which
# would replace this process and prevent the timed-exit logic below from running.
SELECTION="$(cat)"

# Forward to the system clipboard (pass the text via stdin without exec).
printf '%s' "$SELECTION" | "$HOME/.tmux/scripts/clipboard.sh" || true

# Guard: if we don't know which pane we came from, nothing to cancel.
[ -z "$PANE_ID" ] && exit 0

# Spawn the timed-exit in the background, fully detached so it survives
# after this script exits (important on macOS where bash job control may
# otherwise kill child process groups when the parent exits).
(
  sleep "$TIMEOUT"
  # Only cancel if the pane is still in copy mode (manual Escape/q is unaffected)
  if tmux display-message -p -t "$PANE_ID" '#{pane_in_mode}' 2>/dev/null | grep -q '^1$'; then
    tmux send-keys -t "$PANE_ID" -X cancel 2>/dev/null || true
  fi
) &>/dev/null &
disown $!

exit 0
