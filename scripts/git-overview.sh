#!/usr/bin/env bash
# Read-only git snapshot for the current repo, then drop into an interactive
# shell inside the popup so you can run follow-up commands and quit with Ctrl-D.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf '\033[1;34m=== status ===\033[0m\n'
  git -c color.ui=always status -sb
  printf '\n\033[1;34m=== recent history ===\033[0m\n'
  git -c color.ui=always log --graph --oneline --decorate -15
  echo
else
  echo "Not a git repository: $PWD"
  echo
fi
exec "${SHELL:-/bin/zsh}" -l
