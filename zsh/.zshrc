# non system specific shell options 

export PROMPT="%F{green}%~%f:"

export PF_COL1=2
export PF_COL3=1

export FZF_DEFAULT_OPTS="--color=bw --padding=4,4 --tmux=70% --no-scrollbar --no-separator"

fexe() {
  local cmd
  cmd=$(find $(echo "$PATH" | tr ':' '\n') -follow -maxdepth 2 -type f -executable 2>/dev/null \
    | grep -v '^/usr/bin/\[' \
    | sed 's|.*/||' \
    | sort -u \
    | fzf --tmux=70% --border "$@" --preview 'which {} 2>/dev/null && echo && ls -la $(which {} 2>/dev/null)' --preview-window=up:3)

	hyprctl dispatch exec $cmd &> /dev/null
}

alias ls='ls -lha --block-size=M --color=auto'
