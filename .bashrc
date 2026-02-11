# vi:ft=sh
case $(uname -s) in
Darwin)
  PATH=/usr/local/sbin:$PATH
  PATH="/opt/homebrew/opt/go@1.20/bin:$PATH"
  PATH=$(printf '%s:' /opt/homebrew/bin)$PATH
  PATH=$(printf '%s:' /usr/local/opt/*/libexec/gnubin)$PATH
  PATH=$(printf '%s:' /opt/homebrew/opt/*/libexec/gnubin)$PATH
  PATH=$(printf '%s/bin:' ~/.gem/ruby/2.*.*)$PATH
  PATH=~/Library/Python/2.7/bin:$PATH
  MANPATH=$(printf '%s:' /usr/local/opt/*/libexec/gnuman)$MAPATH
  ;;
Linux)
  PATH=$(printf '%s/bin:' ~/.local/share/gem/ruby/*):$PATH
  ;;
esac
PATH=~/.local/bin:$PATH
export MANPATH PATH

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Setup FZF completion and key bindings
. ~/.fzf.bash

### General
bind 'set mark-symlinked-directories on'
shopt -s checkwinsize extglob
export EDITOR=vi VISUAL=vi LESS="-FRSXQ -x2" HISTCONTROL=erasedups

[[ -x /usr/bin/lesspipe ]] && eval "$(lesspipe)"
[ "$TERM" == "rxvt-unicode" ] && [ ! -r /usr/share/terminfo/r/rxvt-unicode ] && {
  export TERM=rxvt
}

# Colors
if [[ $TERM != dumb ]]; then
  if type -p vivid >/dev/null; then
    export LS_COLORS=$(vivid generate molokai)
  elif [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  fi
fi

### Aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias ip='ip -color=auto'

# find nvim, vim or vi
_VI=$(type -p nvim || type -p vim || type -p vi)
if [[ -n $_VI ]]; then
  export EDITOR=$_VI VISUAL=$_VI GIT_EDITOR=$_VI
  alias vi=$_VI vim=$_VI
fi
unset _VI

# prompt
type -p starship >/dev/null && eval "$(starship init bash)"

_oneletter_pwd() {
  local DIRS=() ODIRS=() MAX=0 SHORTEDPATH=''
  IFS=/ read -d '' -a DIRS <<<"${PWD/#$HOME/\~}"
  MAX=$((${#DIRS[@]} - 2)) # show 2 complete names at the end of pwd

  for i in ${!DIRS[@]}; do
    if [[ $i -lt $MAX ]]; then
      ODIRS[$i]=${DIRS[$i]:0:1}
    else
      ODIRS[$i]=${DIRS[$i]}
    fi
  done

  for i in ${!ODIRS[@]}; do
    SHORTEDPATH+=/${ODIRS[$i]}
  done

  echo "${SHORTEDPATH:1}"
}

_tmux_git_rename() {
  # Only run inside tmux
  [ -z "$TMUX" ] && return

  local repo branch short_repo short_branch title

  # Helper: shorten names by acronym if > 10 chars
  _shorten() {
    local s="$1"
    if [ "${#s}" -gt 10 ]; then
      echo "$s" |
        tr '[:punct:]' ' ' |
        tr '[:space:]' ' ' |
        awk '{
          out="";
          for (i=1; i<=NF; i++) out = out substr($i,1,1);
          print out
        }'
    else
      echo "$s"
    fi
  }

  # Try to detect git repo
  repo=$(git rev-parse --show-toplevel 2>/dev/null | xargs basename)

  if [ -n "$repo" ]; then
    short_repo="$(_shorten "$repo")"

    # Get branch (or detached)
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")
    short_branch="$(_shorten "$branch")"

    title="${short_repo}:${short_branch}"
  else
    # Fallback: your custom one-letter path
    title=$(_oneletter_pwd)
  fi

  tmux rename-window "$title"
}

PROMPT_COMMAND="_tmux_git_rename; $PROMPT_COMMAND"

# ssh session agnostic agent path
if [[ -z "$SSH_AUTH_SOCK" && -S "/run/user/$(id -u)/gnupg/S.gpg-agent.ssh" ]]; then
  export SSH_AUTH_SOCK="/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
elif [[ -n "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]]; then
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh_auth_sock
  export SSH_AUTH_SOCK=~/.ssh_auth_sock
fi

### Others
# debian packaging
export DEBFULLNAME='Daniel Graña' DEBEMAIL='dangra@gmail.com'
# mysql client prompt
export MYSQL_PS1="${SQDN%%.*} \u@\h \d> "
# Teleport
export TELEPORT_LOGIN=root
### Android Studio
export ANDROID_SDK_ROOT=/home/daniel/Android/Sdk
### GO lang
export GOPATH=~/go PATH=$PATH:~/go/bin
### Python Poetry
export PATH="$HOME/.poetry/bin:$PATH"
# ruby bundle
#type -p ruby >/dev/null && export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
# Google Cloud SDK
[[ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc ]] &&
  . /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc

[[ -r ~/.cargo/env ]] && . ~/.cargo/env
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -r ~/.bashrc-local ]] && . ~/.bashrc-local
