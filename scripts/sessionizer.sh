#!/usr/bin/env bash
# tmux project launcher ("sessionizer").
#
# Pick a project directory with fzf, then jump to a session named after it,
# creating that session (rooted in the directory) the first time. Run it again
# later and you land right back in the same session. Works both inside tmux
# (switch-client) and from a bare shell (attach).
set -euo pipefail

if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed. Please install it to use this feature."
  read -r -p "Press Enter to close..."
  exit 1
fi

# Directories whose immediate children are projects. Only existing ones are used.
roots=("$HOME/code" "$HOME/dev" "$HOME/projects" "$HOME/work" "$HOME/src" "$HOME/.config")
dirs=()
for r in "${roots[@]}"; do [ -d "$r" ] && dirs+=("$r"); done
[ ${#dirs[@]} -gt 0 ] || { echo "no project roots found"; sleep 1; exit 0; }

selected=$(
  { for r in "${dirs[@]}"; do
      echo "$r"
      find "$r" -mindepth 1 -maxdepth 1 -type d ! -name '.*'
    done; } | sort -u | fzf --reverse --prompt='project> ' --exit-0
) || exit 0
[ -n "${selected:-}" ] || exit 0

# Session names cannot contain dots or colons; spaces are awkward. Sanitize.
name=$(basename "$selected" | tr '. :' '___')

tmux has-session -t="$name" 2>/dev/null || tmux new-session -ds "$name" -c "$selected"

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$name"
else
  tmux attach -t "$name"
fi
