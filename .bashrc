# vi:ft=sh
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
    eval "$(dircolors -b)"
    alias ls='ls --color=auto' 
}
alias ll='ls -l'
alias grep='grep --color'
alias mq='hg -R $(hg root)/.hg/patches'
alias dotfiles="GIT_DIR=~/.dotfiles/.git GIT_WORK_TREE=~ git"
complete -o bashdefault -o default -o nospace -F _git dotfiles
VI=`type -p vim || type -p vi`
[[ -n $VI ]]&& alias vi=$VI vim=$VI

### Used terminal colours
# http://en.wikipedia.org/wiki/ANSI_escape_code
# foreground in range 30-37, # background in range 40-47
# black=0 red=1 green=2 yellow=3 blue=4 magenta=5 cyan=6 white=7
# normal=0 bright=1 faint=2
_term_colour() { eval "$1='\[\e[$2m\]'"; }
_term_colour ANSIReset 0
_term_colour NormalRed "0;31"
_term_colour LightRed "1;31"
_term_colour LightGreen "1;32"
_term_colour LightYellow "1;33"
_term_colour LightBlue "1;34"
_term_colour LightMagenta "1;35"
_term_colour LightCyan "1;36"
_term_colour LightWhite "1;37"
_term_colour FaintGray "2;37"
unset _term_colour

### Prompts
# mysql client prompt
export MYSQL_PS1="$(hostname -s) \u@\h \d> "

# bash prompt
FQDN=`hostname -f || hostname`
case $FQDN in
    *dev.mydeco.com)
        PCOLOUR=$LightCyan; SQDN=${FQDN/.mydeco.com/} ;;
    *mydeco.com)
        PCOLOUR=$LightYellow; SQDN=${FQDN/.mydeco.com/} ;;
    *)
		if [[ -n $WINDOWID ]]; then
        	PCOLOUR=$LightGreen; SQDN=''
		else
        	PCOLOUR=$LightMagenta; SQDN=${FQDN/.*/}
		fi
		;;
esac

_oneletter_pwd() {
    local DIRS=() ODIRS=() MAX=0 SHORTEDPATH=''
    IFS=/ read -d '' -a DIRS <<<"${PWD/#$HOME/~}"
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
    echo ${SHORTEDPATH:1}
}

_prompt_vcs() {
	local hgprompt gitroot gitbranch gitstat gitstatus
	[[ -d .svn ]] && { echo svn; return; }

	gitroot=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ $gitroot ]]; then
		gitbranch=$(git branch 2>/dev/null |sed -rne '/^\*/s/^\*( | master)//p')
		gitstat=$(git status 2>/dev/null | grep '\(# Untracked\|# Changes\|# Changed but not updated:\)')
		[[ $gitstat =~ 'Changes to be committed' ]] && gitstatus='!'
		[[ $gitstat =~ 'Changed but not updated' || $gitstat =~ 'Untracked files' ]] && gitstatus='?'
		echo "${LightWhite}± ${gitroot##*/}${gitstatus:+${LightRed}${gitstatus}}${gitbranch:+ ${LightYellow}${gitbranch}}${ANSIReset}"
		return
	fi

	hgprompt=$(hg prompt --angle-brackets "${LightWhite}☿ <root|basename><${LightRed}<status>><update>< ${LightYellow}<patch>>${ANSIReset}" 2>/dev/null)
	if [[ $hgprompt ]]; then
		echo -e "$hgprompt"
		return
	fi
}

_prompt_command() {
    local sp=$(_oneletter_pwd) vcs=$(_prompt_vcs) hc=$LightWhite ve
    [[ $USER = root ]] && hc="$NormalRed"
    [[ $VIRTUAL_ENV ]] && ve="${LightYellow}${VIRTUAL_ENV##*/}"
    PS1="${FaintGray}\A " # prefix time in HH:MM format
    PS1+="${ve:+$ve }${vcs:+$vcs }" # virtualenv + vcs
    PS1+="${hc}${SQDN:+$SQDN:}${PCOLOUR}" # hostname
    PS1+="${sp}${LightWhite}\\$ ${ANSIReset}" # shorted path
    [[ $INSIDESCREEN ]] && echo -ne "\ek${sp}\e\\" # update screen status line
}
export PS1 PROMPT_COMMAND=_prompt_command

### Others
# ssh session agnostic agent path
if [ -n "$SSH_AUTH_SOCK" -a ! -L "$SSH_AUTH_SOCK" -a -S "$SSH_AUTH_SOCK" ]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh_auth_sock
    export SSH_AUTH_SOCK=~/.ssh_auth_sock
fi

# virtualenv options and mini wrapper with completion support
export VIRTUALENV_USE_DISTRIBUTE=1 VIRTUAL_ENV_DISABLE_PROMPT=1
export WORKON_HOME=~/envs
workon () { source $WORKON_HOME/$1/bin/activate; }
_workon() { COMPREPLY=( $(cd $WORKON_HOME; ls -d ${COMP_WORDS[1]}*) ); }
complete -o default -o nospace -F _workon workon

# load system completions if available
[ -f /etc/bash_completion ] && {
    source /etc/bash_completion
    complete -F _ssh pk
}
