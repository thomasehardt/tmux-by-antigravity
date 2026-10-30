#!/usr/bin/env bash
set -euo pipefail

# Tests the Claude Code tab badge end to end: claude/tmux-status.sh writes
# @claude_state on a window, and tmux.conf renders it on the window tab.
# Runs on its own tmux socket so it never touches your real sessions.

echo "=> Testing Claude Code tab badge..."

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="$ROOT/tmux.conf"
HOOK="$ROOT/claude/tmux-status.sh"
SOCK=test_claude_status

tmux -L "$SOCK" -f "$CONFIG_FILE" new-session -d -s test_claude
trap 'tmux -L "$SOCK" kill-server 2>/dev/null || true' EXIT

PANE="$(tmux -L "$SOCK" display -p -t test_claude '#{pane_id}')"
SOCKET_PATH="$(tmux -L "$SOCK" display -p '#{socket_path}')"

FAILED=0

# Run the hook the way Claude Code does: inside the pane's tmux, with
# $TMUX_PANE set. Pointing $TMUX at the test socket keeps plain `tmux`
# calls in the hook on that socket.
hook() {
    TMUX="$SOCKET_PATH,0,0" TMUX_PANE="$PANE" "$HOOK" "$@"
}

state() {
    tmux -L "$SOCK" display -p -t "$PANE" '#{@claude_state}'
}

tab() {
    tmux -L "$SOCK" display -p -t "$PANE" '#{T:window-status-format}'
}

check() {
    local desc=$1 actual=$2 expected=$3
    if [[ "$actual" == "$expected" ]]; then
        echo "✓ $desc"
    else
        echo "✗ $desc (expected '$expected', got '$actual')"
        FAILED=1
    fi
}

check_contains() {
    local desc=$1 actual=$2 needle=$3
    if [[ "$actual" == *"$needle"* ]]; then
        echo "✓ $desc"
    else
        echo "✗ $desc (expected '$actual' to contain '$needle')"
        FAILED=1
    fi
}

check_lacks() {
    local desc=$1 actual=$2 needle=$3
    if [[ "$actual" != *"$needle"* ]]; then
        echo "✓ $desc"
    else
        echo "✗ $desc (expected '$actual' not to contain '$needle')"
        FAILED=1
    fi
}

hook working </dev/null
check "working sets the state" "$(state)" "working"
check_contains "working shows … on the tab" "$(tab)" "…"

echo '{"notification_type":"permission_prompt"}' | hook waiting
check "waiting sets the state" "$(state)" "waiting"
check_contains "waiting shows ● on the tab" "$(tab)" "●"

hook done </dev/null
check "done sets the state" "$(state)" "done"
check_contains "done shows ✓ on the tab" "$(tab)" "✓"

echo '{"notification_type":"idle_prompt"}' | hook waiting
check "an idle_prompt reminder leaves done alone" "$(state)" "done"

hook error </dev/null
check "error sets the state" "$(state)" "error"
check_contains "error shows ✗ on the tab" "$(tab)" "✗"

hook clear </dev/null
check "clear removes the state" "$(state)" ""
for glyph in "…" "●" "✓" "✗"; do
    check_lacks "a cleared tab shows no $glyph" "$(tab)" "$glyph"
done

hook bogus </dev/null
check "an unknown state is ignored" "$(state)" ""

if env -u TMUX_PANE "$HOOK" working </dev/null; then
    echo "✓ outside tmux the hook exits 0"
else
    echo "✗ outside tmux the hook failed"
    FAILED=1
fi

if [ $FAILED -eq 1 ]; then
    echo "Some Claude badge checks failed."
    exit 1
fi
echo "All Claude badge checks passed!"
