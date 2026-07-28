#!/usr/bin/env bash
# copy-and-timed-exit.sh
# Pipe stdin to the system clipboard, then exit copy mode after a short delay.
#
# Usage (from tmux bind):
#   bind -T copy-mode-vi y send -X copy-pipe "~/.tmux/scripts/copy-and-timed-exit.sh"
#
# COPY_MODE_TIMEOUT (seconds) can be overridden by the caller or environment.
TIMEOUT="${COPY_MODE_TIMEOUT:-3}"

# Forward to the real clipboard handler
"$HOME/.tmux/scripts/clipboard.sh"

# After the delay, cancel copy mode on the pane that triggered the copy.
# We capture the pane ID now (before the sleep) so the reference stays valid.
PANE_ID="$TMUX_PANE"

(
  sleep "$TIMEOUT"
  # Only cancel if the pane still exists and is still in copy mode
  if tmux display-message -p -t "$PANE_ID" '#{pane_in_mode}' 2>/dev/null | grep -q '^1$'; then
    tmux send-keys -t "$PANE_ID" -X cancel
  fi
) &

exit 0
