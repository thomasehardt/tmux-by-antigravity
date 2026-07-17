#!/usr/bin/env bash
# Render the tmux cheatsheet inside a popup. Press q to close.
# Uses bat for syntax highlighting if present, otherwise falls back to less.
set -euo pipefail
f="$HOME/.tmux/cheatsheet.md"
[ -f "$f" ] || { echo "no cheatsheet at $f"; sleep 1; exit 0; }
export LESSKEYIN="$(mktemp)"
printf "#command\n\e quit\n" > "$LESSKEYIN"
trap 'rm -f "$LESSKEYIN"' EXIT

if command -v glow >/dev/null 2>&1; then
  glow -p "$f"
elif command -v bat >/dev/null 2>&1; then
  bat --style=plain --paging=always --language=markdown "$f"
else
  less -R "$f"
fi
