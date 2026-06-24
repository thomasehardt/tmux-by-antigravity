#!/usr/bin/env bash
set -euo pipefail

echo "=> Testing keystroke bindings in tmux config..."

CONFIG_FILE="$(cd "$(dirname "$0")/.." && pwd)/tmux.conf"
tmux -L test_sock -f "$CONFIG_FILE" new-session -d -s test_keystrokes

MISSING_KEYS=0

check_key() {
    local key=$1
    local expected_cmd=$2
    # We grep the list-keys output. tmux parses and normalizes the commands.
    if tmux -L test_sock list-keys | grep -E "bind-key +-T prefix +$key " | grep -q "$expected_cmd"; then
        echo "✓ Prefix + $key is correctly bound to a command containing '$expected_cmd'"
    else
        echo "✗ Prefix + $key is NOT properly bound to '$expected_cmd'"
        tmux -L test_sock list-keys | grep -E "bind-key +-T prefix +$key " || true
        MISSING_KEYS=1
    fi
}

check_key "g" "lazygit"
check_key '\\\\' "scratch.sh"
check_key "b" "btm \|\| htop \|\| top"
check_key "s" "sessions.sh"
check_key "w" "windows.sh"
check_key "u" "url-open.sh"
check_key "f" "sessionizer.sh"
check_key "S" "synchronize-panes"
check_key "P" "pipe-pane"
check_key "I" "cheatsheet.sh"
check_key "m" "display-menu"

tmux -L test_sock kill-server

if [ $MISSING_KEYS -eq 1 ]; then
    echo "Some keys were not properly bound."
    exit 1
fi
echo "All custom keystrokes are properly bound!"
