# Setup fzf
# ---------
if [[ -d /usr/local/opt/fzf ]]; then
  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
  fi

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

  # Key bindings
  # ------------
  source "/usr/local/opt/fzf/shell/key-bindings.bash"
elif [[ -d /usr/share/doc/fzf ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
elif [[ -d /usr/share/fzf/ ]]; then
  . /usr/share/fzf/key-bindings.bash
  . /usr/share/fzf/completion.bash
fi
