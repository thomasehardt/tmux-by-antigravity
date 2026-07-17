#!/usr/bin/env bash

# Trap SIGINT (Ctrl-C) to clean up curl and exit
trap 'kill $pid 2>/dev/null; exit 0' SIGINT SIGTERM

# Run curl in the background
curl -s parrot.live &
pid=$!

# Wait for a keypress
while read -r -s -n 1 key; do
    # If the key is ESC (escape character), break the loop
    if [[ $key == $'\e' ]]; then
        break
    fi
    # If the key is 'q', break as well
    if [[ $key == 'q' ]]; then
        break
    fi
done

# Clean up the curl process before exiting
kill $pid 2>/dev/null
exit 0
