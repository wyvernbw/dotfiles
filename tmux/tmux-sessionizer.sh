#!/usr/bin/env bash

# Prompt the user to choose a directory using zoxide
DIR=$(zoxide query -i)

# Exit if no selection
[ -z "$DIR" ] && exit 0

# Use the basename of the folder as the session name
SESSION_NAME=$(basename "$DIR")

# Create the session if it doesn't exist
tmux has-session -t "$SESSION_NAME" 2>/dev/null
if [ $? != 0 ]; then
    tmux new -s "$SESSION_NAME" -c "$DIR" -d
fi

# Switch to the session
tmux switch-client -t "$SESSION_NAME"
