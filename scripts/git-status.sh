#!/usr/bin/env bash
# Usage: git-status.sh <path>

cd "$1" || exit 0

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ "$branch" = "HEAD" ]; then
    branch=$(git rev-parse --short HEAD 2>/dev/null)
fi

# Check if there are uncommitted changes (tracked or untracked)
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    status="#[fg=#f38ba8,bold]*#[default]" # Red asterisk for dirty
else
    status="" # Clean
fi

# Output with a leading space so it spaces nicely from the path
echo -n " #[fg=#a6e3a1] $branch$status"
