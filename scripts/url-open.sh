#!/usr/bin/env bash
# Scrape URLs out of the current pane's visible scrollback, pick one with fzf,
# and open it with the OS default browser/handler.
set -euo pipefail
urls=$(tmux capture-pane -p -J -S -3000 \
  | grep -oE '(https?|ftp|file)://[A-Za-z0-9._~:/?#@!$&'\''()*+,;=%-]+' \
  | sed -E 's/[).,;:!?]+$//' \
  | sort -u || true)
if [ -z "${urls:-}" ]; then
  echo "No URLs found in this pane's scrollback."
  sleep 1.2
  exit 0
fi
choice=$(printf '%s\n' "$urls" | fzf --reverse --prompt='open url> ' --height=100% --no-multi) || exit 0
if [ -n "${choice:-}" ]; then
  if command -v open >/dev/null 2>&1; then
    open "$choice"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$choice"
  fi
fi
