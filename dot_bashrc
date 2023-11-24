# vi:ft=sh
case $(uname -s) in
  Darwin)
    PATH=/usr/local/sbin:$PATH
    PATH=$(printf '%s:' /usr/local/opt/*/libexec/gnubin)$PATH
    PATH=$(printf '%s/bin:' ~/.gem/ruby/2.*.*)$PATH
    PATH=~/Library/Python/2.7/bin:$PATH
    MANPATH=$(printf '%s:' /usr/local/opt/*/libexec/gnuman)$MAPATH
    ;;
  Linux)
    #PATH=~/.gem/ruby/2.2.0/bin:/sbin:/usr/sbin:$PATH
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
[[ -n $_VI ]] && alias vi=$_VI vim=$_VI
unset _VI

# prompt
type -p starship >/dev/null && eval "$(starship init bash)"

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
[[ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc ]] && \
  . /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc

[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
