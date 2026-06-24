# Tmux Configuration

This repository contains my personal, custom tmux configuration, managed by a custom `tmux-mgr` CLI tool.

## Installation

The easiest way to install this configuration is using the bootstrap script. It will clone the repository into a hidden, safe directory (`~/.local/share/tmux-mgr`), safely back up any of your existing tmux configuration, and install the `tmux-mgr` CLI tool.

Run this command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/thomasehardt/tmux-by-antigravity/main/install.sh | bash
```

Once installed, you can use the `tmux-mgr` command to manage your setup:
- `tmux-mgr update`: Fetch the latest config from GitHub and reload tmux.
- `tmux-mgr edit`: Open the `tmux.conf` file in your editor.
- `tmux-mgr status`: Check your installation status.

*Note: Make sure `~/.local/bin` is in your `$PATH`!*

## Documentation & Decision Log

To maintain a clean and understandable configuration, we will document all major additions, keybindings, and plugins here along with the reasoning behind them. We will also ensure the `tmux.conf` file itself remains heavily commented.

### Decision Log

* **2026-06-23**: 
  * **Decision**: Disabled the previous `oh-my-tmux` framework (backed up in `backup/`) to start a fresh, custom configuration.
  * **Reasoning**: To gain full control over the environment and reduce unnecessary complexity or unused features that come with large frameworks.

* **2026-06-23**: 
  * **Decision**: Applied a "Minimum Viable Configuration" including Mouse Support, Base-1 Indexing, `Ctrl+a` Prefix, intuitive splits (`|` and `-`), and Vi-mode.
  * **Reasoning**: Creates a highly productive, sane baseline. `Ctrl+a` is ergonomic; 1-based indexing aligns with the physical keyboard; and intuitive splits are easier to remember.

* **2026-06-23**:
  * **Decision**: Added Vim-like pane navigation (`Prefix + h/j/k/l`) and repeatable pane resizing (`Prefix + H/J/K/L`).
  * **Reasoning**: A major best-practice for Vim users to maintain muscle memory across the terminal. Using the `-r` flag for resizing allows holding the resize keys without repeatedly having to hit the prefix.

* **2026-06-23**:
  * **Decision**: Applied a handcrafted, minimal "Catppuccin Mocha" inspired color scheme directly to the status bar.
  * **Reasoning**: The default tmux green is notoriously harsh and outdated. Applying a modern palette (deep dark background with soft blue accents) directly in the config provides a sleek aesthetic without needing to install heavy third-party theme plugins.

* **2026-06-23**:
  * **Decision**: Mapped `v` and `y` in copy mode to emulate Vim visual selection and yank, and integrated them with the Linux system clipboard (`xclip`).
  * **Reasoning**: By default, tmux has clunky copy bindings (like Space and Enter) and only copies to its internal buffer. This change ensures that when you copy text in tmux, it instantly goes to your OS clipboard so you can paste it in your browser or other native apps.

* **2026-06-24**:
  * **Decision**: Added a suite of helper scripts in `scripts/` (e.g., fuzzy session switching, scratch shells) and a `cheatsheet.md` that displays via popup.
  * **Reasoning**: Decouples complex workflow logic from `tmux.conf` to keep the core config clean while enabling IDE-like features. A dedicated popup cheatsheet improves discoverability for custom bindings.

* **2026-06-24**:
  * **Decision**: Refactored `battery.sh`, `sys-stats.sh`, and `url-open.sh` to dynamically detect the OS and use Linux-compatible tools (`xdg-open`, `/sys/class/power_supply/`, `uptime`/`free`) when macOS native binaries are unavailable.
  * **Reasoning**: Ensures the configuration is truly cross-platform and can be seamlessly deployed on macOS, Linux desktops, or headless Linux servers without breaking the status bar or custom keybindings.
