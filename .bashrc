# ~/.bashrc: executed by bash(1) for non-login shells.
export PATH=~/bin:/sbin:/usr/sbin:$PATH

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

### General
shopt -s checkwinsize
export EDITOR=vi
export VISUAL=vi
export HISTCONTROL=erasedups
export ACK_COLOR_FILENAME=magenta
export ACK_COLOR_MATCH=red
[[ ${TERM:0:6} == screen ]] && INSIDESCREEN=1
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
[ "$TERM" == "rxvt-unicode" ] && [ ! -r /usr/share/terminfo/r/rxvt-unicode ] && {
    export TERM=rxvt
}

### Aliases
[ "$TERM" != "dumb" ] && {
    eval "`dircolors -b`"
    alias ls='ls --color=auto' 
}
alias ll='ls -l'
alias grep='grep --color'
alias ygrep="grep -E -R --include='*.py'"
alias t=todo.sh
alias mq='hg -R $(hg root)/.hg/patches'
VI=`type -p vim || type -p vi`
[[ -n $VI ]]&& alias vi=$VI vim=$VI

### Prompts
export MYSQL_PS1="$(hostname -s) \u@\h \d> "
. ~/.termcolors
FQDN=`hostname -f || hostname`
case $FQDN in
    vanqak*|vostro*)
        PROMPT_COLOUR=GREEN_BOLD
		SHORTDN=''
        ;;
    triosko*)
        PROMPT_COLOUR=MAGENTA_BOLD
		SHORTDN=${FQDN/.*/}
		;;
    *dev.mydeco.com)
        PROMPT_COLOUR=CYAN_BOLD
        SHORTDN=${FQDN/.mydeco.com/}
        ;;
    *mydeco.com)
        PROMPT_COLOUR=YELLOW_BOLD
        SHORTDN=${FQDN/.mydeco.com/}
        ;;
	*)
		PROMPT_COLOUR=YELLOW_BOLD
		SHORTDN=${FQDN/.*/}
		;;
esac

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
_prompt_command_oneletter() {
    local shortpwd=$(_oneletter_pwd)
    test `id -u` -eq 0 && hostcolour="$RED_BOLD" || hostcolour="$WHITE_BOLD"
    PS1="${hostcolour}${SHORTDN}:${NOCOLOR}${!PROMPT_COLOUR}"
    PS1+="$shortpwd${NOCOLOR}${WHITE_BOLD}\\$ ${NOCOLOR}"

	# XXX: breaks linux console prompt
    #[[ $INSIDESCREEN ]] \
    #    && echo -ne "\ek$shortpwd\e\\" \
    #    || echo -ne "\e]0;$HOSTNAME:$shortpwd\007"
}
_prompt_command () {
    [[ -S $SSH_AUTH_SOCK ]] || source ~/.fwd-auth-sock #2>/dev/null
    _prompt_command_oneletter
}
export PS1 PROMPT_COMMAND=_prompt_command

### Completion
[ -f /etc/bash_completion ] && source /etc/bash_completion
complete -F _ssh pk

### Title
_title () {
    local _last=$(history 1 |awk '{print $2}')
    _last=$(basename "$_last")
    [[ $INSIDESCREEN ]] \
        && echo -ne "\ek${_last}\e\\" \
        || echo -ne "\e]0;$HOSTNAME:${_last}\007"
}
#XXX: breaks linux console prompt
#trap _title DEBUG

### Others
# if not inside screen session and a valid ssh auth socked is defined
# overwrite socket pointer file so screen sessions can be updated
[[ -z "$INSIDESCREEN" && -S "$SSH_AUTH_SOCK" ]] \
    && echo "export SSH_AUTH_SOCK='$SSH_AUTH_SOCK'" >~/.fwd-auth-sock
export PATH=$HOME/src/git/sup/bin:$PATH
export RUBYLIB=$HOME/src/git/sup/lib

## #Overrides
[ -f ~/.bash_aliases ]&&source ~/.bash_aliases
[ -r ~/.bash.local ]&&source ~/.bash.local
