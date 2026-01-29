#!/bin/bash

SESSION_NAME="ny"
TARGET_DIR="/run/media/mohamed/Mohamed/Mohameds place/X.co/Nytrogen - Compiler/Nytro-0.1"

# Kill existing session if it exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux kill-session -t "$SESSION_NAME"
fi

# Create new tmux session in detached mode
tmux new-session -d -s "$SESSION_NAME" -c "$TARGET_DIR"

# Create window for neovim (name: neovim)
tmux new-window -t "$SESSION_NAME" -c "$TARGET_DIR" -n "neovim"

# Create window for gemini (name: gemini)
tmux new-window -t "$SESSION_NAME" -c "$TARGET_DIR" -n "gemini"

# Attach to the first window (bash shell)
tmux attach-session -t "$SESSION_NAME"
