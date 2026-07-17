#!/usr/bin/env bash

# This script runs when a tmux client attaches, or immediately after an update.

if [ -f "$HOME/.tmux/.show_cheatsheet" ]; then
    rm -f "$HOME/.tmux/.show_cheatsheet"
    tmux display-popup -E -w 80% -h 80% "~/.tmux/scripts/cheatsheet.sh"
elif [ -f "$HOME/.tmux/.show_changelog" ]; then
    # We want to display the changelog, but we need to pass the file contents to the popup
    tmux display-popup -E -w 80% -h 80% "echo '🎉 Tmux configuration updated!'; echo ''; cat '$HOME/.tmux/.show_changelog'; echo ''; rm -f '$HOME/.tmux/.show_changelog'; read -r -p 'Press Enter to continue...'"
fi
