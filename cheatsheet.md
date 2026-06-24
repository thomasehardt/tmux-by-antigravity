# tmux cheatsheet

Prefix is `Ctrl-a`. Notation below: `prefix x` means press Ctrl-a, release, then x.
Send a literal Ctrl-a to the program inside with `Ctrl-a Ctrl-a`.

## Panes

| Key | Action |
| --- | --- |
| `prefix \|` | Split left/right (new pane in current dir) |
| `prefix -` | Split top/bottom (new pane in current dir) |
| `prefix h j k l` | Move to pane left / down / up / right |
| `prefix H J K L` | Resize pane (hold to repeat) |
| `prefix z` | Zoom pane (toggle fullscreen) |
| `prefix x` | Kill pane (asks first) |

## Windows

| Key | Action |
| --- | --- |
| `prefix c` | New window (in current dir) |
| `prefix C-h` / `prefix C-l` | Previous / next window (repeatable) |
| `Shift-Left` / `Shift-Right` | Previous / next window (no prefix) |
| `prefix Tab` | Last window |

## Sessions and projects

| Key | Action |
| --- | --- |
| `prefix f` | Project launcher: fzf over repos, jump to a session for it |
| `prefix s` | Fuzzy session switcher |
| `prefix w` | Fuzzy window switcher (across all sessions) |
| `prefix C-s` | Save all sessions/windows/layouts to disk |
| `prefix C-r` | Restore saved sessions (fresh shells, right dirs) |

## Popups (float over your work, vanish on exit)

| Key | Action |
| --- | --- |
| `prefix \` | Scratch shell (persistent; keeps whatever you leave running) |
| `prefix g` | Git overview for the current repo, then a shell |
| `prefix G` | Full-screen lazygit in a popup |
| `prefix b` | System monitor (btm/htop/top) in a popup |
| `prefix u` | Pick a URL off the screen and open it |

## Copy and paste

| Key | Action |
| --- | --- |
| `prefix [` | Enter copy mode |
| `prefix F` | Fast, hint-based text selection/copying directly from the screen |
| `v` | Start selection (in copy mode) |
| `y` or `Enter` | Copy selection to the system clipboard |
| mouse drag | Copy selection to the system clipboard |
| `/` `?` | Search forward / back (in copy mode) |
| `prefix ]` | Paste the tmux buffer |

Copy works on any OS: macOS, Linux (Wayland/X11), or WSL, and over SSH via OSC 52.

## Toggles and tools

| Key | Action |
| --- | --- |
| `prefix S` | Broadcast typing to every pane (SYNC badge shows when on) |
| `F12` | Toggle "Inception Mode" (passes all keys to a nested tmux/SSH session) |
| `prefix P` | Log this pane to ~/.tmux/logs/ (toggle) |
| `prefix m` | Actions menu (everything above, clickable) |
| `prefix I` | This cheatsheet |
| `prefix ?` | Full, live key list (auto-generated) |
| `prefix r` | Reload config |
| `prefix t` | Clock |

## Reading the status bar

- Left: session name, then badges that light up only when active:
  **PREFIX** (waiting for a key), **COPY** (copy mode), **SYNC** (broadcast on).
- Right: current path, `load` + memory used %, battery, date, time.
- Pane borders are labeled `index:command` (the active one is blue).

## Where things live

- Config: `~/.tmux.conf`
- Helper scripts: `~/.tmux/scripts/`
- Pane logs: `~/.tmux/logs/`
- Saved sessions: `~/.tmux/resurrect/last.txt`
- Backup of the pre-overhaul config: `~/.tmux/backup/tmux.conf.backup`
