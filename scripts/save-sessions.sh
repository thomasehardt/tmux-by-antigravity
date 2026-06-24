#!/usr/bin/env bash
# Snapshot the current tmux server to a flat, tab-delimited file so it can be
# rebuilt later by restore-sessions.sh. We capture the shape of things:
#   w<TAB>session<TAB>window_index<TAB>active<TAB>layout<TAB>window_name
#   p<TAB>session<TAB>window_index<TAB>pane_index<TAB>active<TAB>cwd
# Running programs are intentionally NOT saved (that path is fragile); restore
# rebuilds the window/pane layout and working directories with fresh shells.
set -euo pipefail

dir="$HOME/.tmux/resurrect"
mkdir -p "$dir"
f="$dir/last.txt"

{
  tmux list-windows -a -F 'w	#{session_name}	#{window_index}	#{?window_active,1,0}	#{window_layout}	#{window_name}'
  tmux list-panes   -a -F 'p	#{session_name}	#{window_index}	#{pane_index}	#{?pane_active,1,0}	#{pane_current_path}'
} > "$f"

n=$(grep -c '^w	' "$f" 2>/dev/null || true)
tmux display-message "tmux: saved ${n:-0} windows -> $f"
