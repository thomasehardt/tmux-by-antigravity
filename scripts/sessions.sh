#!/usr/bin/env bash
# fzf session switcher. Lists every session except the current one and
# switches the underlying client to whatever you pick.
set -euo pipefail
current=$(tmux display-message -p '#S')
target=$(tmux list-sessions -F '#{session_name}' \
  | grep -vxF "$current" \
  | fzf --reverse --prompt='session> ' --exit-0 --select-1 --height=100%) || exit 0
[ -n "${target:-}" ] && tmux switch-client -t "$target"
