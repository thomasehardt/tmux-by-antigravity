#!/usr/bin/env bash
# fzf session switcher. Lists every session except the current one and
# switches the underlying client to whatever you pick.
set -euo pipefail

if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed. Please install it to use this feature."
  read -r -p "Press Enter to close..."
  exit 1
fi
current=$(tmux display-message -p '#S')
target=$(tmux list-sessions -F '#{session_name}' \
  | grep -vxF "$current" \
  | fzf --reverse --prompt='session> ' --exit-0 --select-1 --height=100%) || exit 0
[ -n "${target:-}" ] && tmux switch-client -t "$target"
