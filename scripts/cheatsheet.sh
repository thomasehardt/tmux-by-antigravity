#!/usr/bin/env bash
# Render the tmux cheatsheet inside a popup. Press q to close.
# Uses bat for syntax highlighting if present, otherwise falls back to less.
set -euo pipefail
f="$HOME/.tmux/cheatsheet.md"
[ -f "$f" ] || { echo "no cheatsheet at $f"; sleep 1; exit 0; }
if command -v bat >/dev/null 2>&1; then
  exec bat --style=plain --paging=always --language=markdown "$f"
else
  exec less -R "$f"
fi
