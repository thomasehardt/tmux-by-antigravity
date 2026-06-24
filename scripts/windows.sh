#!/usr/bin/env bash
# fzf switcher across every window in every session. Jumps the client straight
# to the chosen "session:window", no matter which session it lives in.
set -euo pipefail
target=$(tmux list-windows -a \
    -F '#{session_name}:#{window_index}  #{window_name}  [#{pane_current_command}]' \
  | fzf --reverse --prompt='window> ' --with-nth=1,2,3 --exit-0 --select-1 --height=100% \
  | awk '{print $1}') || exit 0
[ -n "${target:-}" ] && tmux switch-client -t "$target"
