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
