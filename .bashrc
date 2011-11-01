# vi:ft=sh
export PATH=~/bin:/sbin:/usr/sbin:$PATH

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

### General
shopt -s checkwinsize extglob
export EDITOR=vi
export VISUAL=vi
export LESS=-FRSXQ
export HISTCONTROL=erasedups
export ACK_COLOR_FILENAME=magenta
export ACK_COLOR_MATCH=red
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
[ "$TERM" == "rxvt-unicode" ] && [ ! -r /usr/share/terminfo/r/rxvt-unicode ] && {
    export TERM=rxvt
}

### Aliases
[ "$TERM" != "dumb" ] && {
    eval "$(dircolors -b ~/.dircolors)"
    alias ls='ls --color=auto' 
}
alias ll='ls -l'
alias grep='grep --color'
alias mq='hg -R $(hg root)/.hg/patches'
alias dotfiles="GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ git"

# be virtualenv friendly
alias pylint="env python -m pylint.lint"
alias nosetests="env python -m nose.core"
alias trial="env python /usr/bin/trial"
alias twistd="env python /usr/bin/twistd"

complete -o bashdefault -o default -o nospace -F _git dotfiles
VI=`type -p vim || type -p vi`
[[ -n $VI ]]&& alias vi=$VI vim=$VI
[[ $(python -c 'import sys; print sys.version[:3]') < 2.5 ]] && alias python=python2.5
alias egg="python setup.py bdist_egg"

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

ec2_metadata() { curl -fsm1 http://169.254.169.254/latest/meta-data/$1; }
ec2_sqdn() {
	[[ $1 = '-force' || -e /etc/sysconfig/aws ]] || return
	echo $(ec2_metadata security-groups) $(ec2_metadata instance-id) \
		|sed -rne 's/default\s?//;s/ +/-/gp'
}
### Prompts
FQDN=$(hostname -f 2>/dev/null || hostname 2>/dev/null)
PCOLOUR=$LightMagenta
# bash prompt
case $FQDN in
	*.mydeco.com) SQDN=${FQDN/.mydeco.com} ;;
	domU-*|ip-*) SQDN=$(ec2_sqdn) ;;
    *)
		if [[ -n $WINDOWID ]]; then
        	PCOLOUR=$LightGreen; SQDN=''
		else
        	SQDN=${FQDN/.*}
		fi
		;;
esac

# mysql client prompt
export MYSQL_PS1="${SQDN%%.*} \u@\h \d> "

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

	hgprompt=$(test -r /.hg || hg prompt --angle-brackets "${LightWhite}☿ <root|basename><${LightYellow}#<branch|quiet>><${LightRed}<status>><update>< ${LightYellow}<patch>>${ANSIReset}" 2>/dev/null)
	if [[ $hgprompt ]]; then
		echo -e "$hgprompt"
		return
	fi
}

_prompt_command() {
    local shortpwd=$(_oneletter_pwd) vcs=$(_prompt_vcs) sign='\$' hc=$LightWhite ve noescapes
    [[ $USER = root ]] && hc="$NormalRed"
    [[ $VIRTUAL_ENV ]] && ve="${LightYellow}${VIRTUAL_ENV##*/}"
    #PS1="${FaintGray}\A${ANSIReset} " # prefix time in HH:MM format
    PS1="${ve:+$ve }${vcs:+$vcs }" # virtualenv + vcs
    PS1+="${hc}${SQDN:+$SQDN:}${PCOLOUR}${shortpwd}"
	noescapes=${PS1//+(????\[?;??m\\]|????\[?m\\])} # only useful to aprox prompt length
	(( ${#noescapes} * 2 > $COLUMNS )) && sign="\n$sign"
    PS1+="${LightWhite}${sign}${ANSIReset} " # shorted path
    [[ $WINDOW ]] && echo -ne "\ek${shortpwd}\e\\" # update screen status line
}
export PS1 PROMPT_COMMAND=_prompt_command

### Others
# debian packaging
export DEBFULLNAME='Daniel Graña'
export DEBEMAIL='dangra@gmail.com'

# ssh session agnostic agent path
if [ -n "$SSH_AUTH_SOCK" -a ! -L "$SSH_AUTH_SOCK" -a -S "$SSH_AUTH_SOCK" ]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh_auth_sock
    export SSH_AUTH_SOCK=~/.ssh_auth_sock
fi

# virtualenv options and mini wrapper with completion support
export PIP_DOWNLOAD_CACHE=~/.pip_download_cache
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
