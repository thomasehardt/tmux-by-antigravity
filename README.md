# Tmux Configuration

This repository contains my personal, custom tmux configuration.

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
