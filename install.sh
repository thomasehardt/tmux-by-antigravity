#!/usr/bin/env bash
set -euo pipefail

# This script bootstraps the tmux-mgr setup. It clones the repo into a hidden
# safe directory and links the CLI tool into the user's PATH.

REPO_URL="https://github.com/thomasehardt/tmux-by-antigravity.git"
INSTALL_DIR="$HOME/.local/share/tmux-mgr"
BIN_DIR="$HOME/.local/bin"

echo "=> Bootstrapping tmux-mgr..."

if [ -d "$INSTALL_DIR" ]; then
    echo "=> Updating existing installation in $INSTALL_DIR..."
    git -C "$INSTALL_DIR" pull --quiet
else
    echo "=> Cloning repository to $INSTALL_DIR..."
    git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/bin/tmux-mgr" "$BIN_DIR/tmux-mgr"

echo "=> Running tmux-mgr install..."
"$BIN_DIR/tmux-mgr" install

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo ""
    echo "============================================================"
    echo " WARNING: $BIN_DIR is not in your PATH."
    echo " To use the 'tmux-mgr' command globally, please add:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo " to your ~/.bashrc or ~/.zshrc file."
    echo "============================================================"
fi
