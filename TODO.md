# Tmux Configuration TODOs

### 1. Hint-Based Copying
- **Description**: Add a plugin or script like `tmux-thumbs` or `tmux-fingers` (or equivalent fzf-based scraper) to allow fast, keyboard-driven copying of paths, hashes, and IP addresses using two-letter hints directly from the screen without entering copy mode.

### 2. Undercurl Support
- **Description**: Enable colored undercurls (squiggly lines) for Neovim/Vim diagnostics by appending `,Smulx=\E[4::%p1%dm` to the `terminal-overrides` setting in `.tmux.conf`.

### 3. "Inception" Mode (Nested Tmux)
- **Description**: Implement a toggle keybind (e.g., `F12`) that disables the outer tmux session's prefix and bindings. This allows keystrokes to pass straight through to a nested tmux session running over SSH. 
- **Bonus**: Change the status bar color when toggled "off" to provide a clear visual indicator.

### 4. Dedicated TUI Popups
- **Description**: Create hotkeys to instantly launch full-screen, interactive TUI applications in centered floating popups (e.g., Lazygit for git management, or btm/htop for system monitoring). These should close cleanly and return focus to the active pane.
