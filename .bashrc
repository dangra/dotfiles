# ~/.bashrc: executed by bash(1) for non-login shells.

export PATH=~/bin:/sbin:/usr/sbin:$PATH

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# alias
[ -f ~/.bash_aliases ] && builtin source ~/.bash_aliases

[ "$TERM" == "rxvt-unicode" ] && [ ! -r /usr/share/terminfo/r/rxvt-unicode ] && {
    export TERM=rxvt
}

# enable color support of ls and also add handy aliases
[ "$TERM" != "dumb" ] && {
    eval "`dircolors -b`"
    alias ls='ls --color=auto' 
}

alias ll='ls -l'
alias grep='grep --color'
alias ygrep="grep -E -R --include='*.py'"
alias t=todo.sh
alias mq='hg -R $(hg root)/.hg/patches'

# Completions

VI=`type -p vim || type -p vi`
alias vi=$VI
alias vim=$VI

export EDITOR=$VI
export VISUAL=$EDITOR
export HISTCONTROL=erasedups
export ACK_COLOR_FILENAME=magenta
export ACK_COLOR_MATCH=red

. ~/.termcolors

myhost=`hostname -s`

DFT_FG='#aaaaaa'
DFT_BG='#1a1a1a'
DFT_FN='-*-terminus-medium-r-normal-*-12-*-*-*-*-*-*-*'

# custom Xmodmap per hostname
if [ -r ~/.Xmodmap-$myhost ]; then
    XMODMAP=~/.Xmodmap-$myhost
else
    XMODMAP=~/.Xmodmap
fi

[ $DISPLAY ]&&[ -x /usr/bin/xrandr ]&& \
    export $(xrandr -q | sed -nre 's/.*, current ([0-9]+) x ([0-9]+),.*/SCREEN_WIDTH=\1 SCREEN_HEIGHT=\2/;T;p')


CONKY_TEXT='${cpu cpu0} ${loadavg 1 2 3} ${memperc} ${downspeed eth0} ${upspeed eth0}'
PROMPT_COLOUR=cyan_bold

FQDN=`hostname -f || hostname`
SHORTDN=${FQDN/.*/}
case $FQDN in
    filo*)
        PROMPT_COLOUR=yellow_bold;;
    triosko*)
        PROMPT_COLOUR=magenta_bold;;
    vanqak*)
        PROMPT_COLOUR=green_bold
        CONKY_TEXT='${cpu cpu0} ${cpu cpu1} ${loadavg 1 2 3} ${memperc} ${downspeed wlan0} ${upspeed wlan0} ${battery}'
        ;;
    *dev.mydeco.com)
        PROMPT_COLOUR=cyan_bold
        SHORTDN=${FQDN/.mydeco.com/}
        ;;
    *mydeco.com)
        PROMPT_COLOUR=yellow_bold
        SHORTDN=${FQDN/.mydeco.com/}
        ;;
esac


type -p autojump >/dev/null && {
    AUTOJUMP_ENABLED=1
    _autojump() 
    {
        local cur
        COMPREPLY=()
        unset COMP_WORDS[0] #remove "j" from the array
        cur=${COMP_WORDS[*]}
        IFS=$'\n' read -d '' -a COMPREPLY < <(autojump --completion "$cur")
        return 0
    }
    complete -F _autojump j
    alias jumpstat="autojump --stat"
    function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; echo; cd "$new_path";fi }
}


_oneletter_pwd() {
    local DIRS=() ODIRS=()
    IFS=/ read -d '' -a DIRS < <(pwd|sed -e "s!^$HOME!~!")
    local MAX=$((${#DIRS[@]} - 2)) # show 2 complete names at the end of pwd
    for i in ${!DIRS[@]}; do
        if [[ $i -lt $MAX ]]; then
            ODIRS[$i]=${DIRS[$i]:0:1}
        else
            ODIRS[$i]=${DIRS[$i]}
        fi
    done

    local final=''
#     local final=${ODIRS[0]}
#     unset ${ODIRS[0]}
    for i in ${!ODIRS[@]}; do
        final+=/${ODIRS[$i]}
    done
    echo ${final:1}
}

[[ ${TERM:0:6} == screen ]] && INSIDESCREEN=1
PROMPT_COLOUR_NAME=$(tr a-z A-Z <<<$PROMPT_COLOUR)

_prompt_command_oneletter() {
    local shortpwd=$(_oneletter_pwd)
    test `id -u` -eq 0 && hostcolour="$RED_BOLD" || hostcolour="$WHITE_BOLD"
    PS1="${hostcolour}${SHORTDN}:${NOCOLOR}${!PROMPT_COLOUR_NAME}"
    PS1+="$shortpwd${NOCOLOR}${WHITE_BOLD}\\$ ${NOCOLOR}"

    [[ $INSIDESCREEN ]] \
        && echo -ne "\ek$shortpwd\e\\" \
        || echo -ne "\e]0;$HOSTNAME:$shortpwd\007"
}

_prompt_command () {
    [[ -S $SSH_AUTH_SOCK ]] || source ~/.fwd-auth-sock #2>/dev/null
    [[ -n $AUTOJUMP_ENABLED ]] && autojump -a "$(pwd -P)" # autojump
    _prompt_command_oneletter
}

export PS1 PROMPT_COMMAND=_prompt_command
export MYSQL_PS1="$(hostname -s) \u@\h \d> "

#BASH_COMPLETION_DEBUG=1
[ -f /etc/bash_completion ] && source /etc/bash_completion
complete -F _ssh pk

[ -r ~/.bash.local ]&&source ~/.bash.local

_title () {
    local _last=$(history 1 |awk '{print $2}')
    _last=$(basename "$_last")
    [[ $INSIDESCREEN ]] \
        && echo -ne "\ek${_last}\e\\" \
        || echo -ne "\e]0;$HOSTNAME:${_last}\007"
}

trap _title DEBUG
#trap 'echo -ne "\e]0;$BASH_COMMAND\007"' DEBUG

# if not inside screen session and a valid ssh auth socked is defined
# overwrite socket pointer file so screen sessions can be updated
[[ -z "$INSIDESCREEN" && -S "$SSH_AUTH_SOCK" ]] \
    && echo "export SSH_AUTH_SOCK='$SSH_AUTH_SOCK'" >~/.fwd-auth-sock
