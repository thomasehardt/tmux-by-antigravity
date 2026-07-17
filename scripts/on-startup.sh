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
