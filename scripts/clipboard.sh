#!/usr/bin/env bash
# Platform-agnostic "copy to system clipboard" filter.
#
# Reads the selection on stdin and hands it to whatever native clipboard tool
# this OS provides. Used as the target of tmux copy-pipe bindings.
#
# This only covers the *native local* clipboard. tmux's own `set-clipboard on`
# runs in parallel and emits an OSC 52 escape for every copy, which is what
# carries the selection to the terminal over SSH or on terminals/OSes this
# script does not recognize. Together they mean "always reach the system
# clipboard" no matter where tmux is running.
#
# exec is used so stdin streams straight through byte-for-byte (no trailing
# newline mangling from a command substitution).
set -euo pipefail

if command -v pbcopy >/dev/null 2>&1; then
  exec pbcopy                                   # macOS
elif [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null 2>&1; then
  exec wl-copy                                  # Linux / Wayland
elif [ -n "${DISPLAY:-}" ] && command -v xclip >/dev/null 2>&1; then
  exec xclip -selection clipboard               # Linux / X11
elif [ -n "${DISPLAY:-}" ] && command -v xsel >/dev/null 2>&1; then
  exec xsel --clipboard --input                 # Linux / X11 (alternate)
elif command -v clip.exe >/dev/null 2>&1; then
  exec clip.exe                                 # Windows / WSL
else
  # No native tool here (e.g. a headless SSH host). Drain stdin so the pipe
  # closes cleanly; tmux's set-clipboard OSC 52 still delivers the copy.
  exec cat >/dev/null
fi
