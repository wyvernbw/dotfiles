if tmux has-session 2>/dev/null; then
  tmux attach
else
  tmux
fi
