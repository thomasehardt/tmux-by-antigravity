#!/usr/bin/env bash
# Persistent floating scratch session.
# Attaches to the "scratch" session if it exists, otherwise creates it.
# Because it is a real session, anything left running here survives closing
# the popup and is waiting again the next time you open it.
exec tmux new-session -A -s scratch
