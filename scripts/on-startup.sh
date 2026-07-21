#!/usr/bin/env bash

# This script runs when a tmux client attaches.

# Check if the user has disabled this feature in their config
if [ "$(tmux show-option -gv @enable_startup_hint)" == "off" ]; then
    exit 0
fi

# Give tmux a moment to finish its initial layout phase
sleep 0.2

# Set the hint text as a tmux variable so the status bar picks it up inline.
# We format it similarly to the other badges so it stands out nicely.
tmux set-option -g @startup_hint "#[fg=#1e1e2e,bg=#89b4fa,bold] 💡 Press PREFIX (Ctrl-a) + ? for help #[default] "

# Force an immediate redraw of the status bar so it doesn't wait for the 5s interval
tmux refresh-client -S

# Wait 30 seconds
sleep 30

# Clear the hint
tmux set-option -g @startup_hint ""
tmux refresh-client -S

# Check for updates in the background
if [ "$(tmux show-option -gv @enable_auto_update 2>/dev/null)" != "off" ]; then
    INSTALL_DIR="$HOME/.local/share/tmux-mgr"
    LAST_CHECK_FILE="$HOME/.tmux/.tmux-mgr-update"
    NOW=$(date +%s)
    
    if [ -f "$LAST_CHECK_FILE" ]; then
        LAST_CHECK=$(cat "$LAST_CHECK_FILE")
    else
        LAST_CHECK=0
    fi
    
    # Check every 7 days (604800 seconds)
    if [ $((NOW - LAST_CHECK)) -gt 604800 ]; then
        if cd "$INSTALL_DIR"; then
            git fetch origin >/dev/null 2>&1
            LOCAL_HASH=$(git rev-parse HEAD)
            REMOTE_HASH=$(git rev-parse origin/main 2>/dev/null || echo "unknown")
            
            if [ "$LOCAL_HASH" != "$REMOTE_HASH" ] && [ "$REMOTE_HASH" != "unknown" ]; then
                tmux set-option -g @update_hint "#[fg=#1e1e2e,bg=#f9e2af,bold] 🚀 tmux-mgr update available! Run 'tmux-mgr update' #[default] "
                tmux refresh-client -S
            fi
            echo "$NOW" > "$LAST_CHECK_FILE"
        fi
    fi
fi
