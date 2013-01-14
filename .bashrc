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
alias egg="python setup.py bdist_egg"

# be virtualenv friendly
alias pylint="env python -m pylint.lint"
alias nosetests="env python -m nose.core"
alias trial="env python /usr/bin/trial"
alias twistd="env python /usr/bin/twistd"

# dotfiles git wrapper
alias dotfiles="GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ git"
alias dottig="GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ tig"
complete -o bashdefault -o default -o nospace -F _git dotfiles

# find vim or vi
VI=`type -p vim || type -p vi`
[[ -n $VI ]]&& alias vi=$VI vim=$VI

### Used terminal colours
# http://en.wikipedia.org/wiki/ANSI_escape_code
# foreground in range 30-37, # background in range 40-47
# black=0 red=1 green=2 yellow=3 blue=4 magenta=5 cyan=6 white=7
# normal=0 bright=1 faint=2
_termcol() { local co="\\[\\e[$1m\\]"; shift; for n in "$@"; do eval "$n='$co';"; done;}
_termcol "0" ANSIReset
_termcol "0;30" Black Base02
_termcol "0;31" Red
_termcol "0;32" Green
_termcol "0;33" Yellow
_termcol "0;34" Blue
_termcol "0;35" Magenta
_termcol "0;36" Cyan
_termcol "0;37" White Base2
_termcol "1;30" BrBlack Base03
_termcol "1;31" BrRed Orange
_termcol "1;32" BrGreen Base01
_termcol "1;33" BrYellow Base00
_termcol "1;34" BrBlue Base0
_termcol "1;35" BrMagenta Violet
_termcol "1;36" BrCyan Base1
_termcol "1;37" BrWhite Base3
_termcol "2;37" FaintGray
unset _termcol

# AWS
ec2_metadata() { curl -fsm1 http://169.254.169.254/latest/meta-data/$1; }
ec2_sqdn() {
    [[ $1 = '-force' || -e /etc/sysconfig/aws ]] || return
    echo $(ec2_metadata security-groups) $(ec2_metadata instance-id) \
        |sed -rne 's/default\s?//;s/ +/-/gp'
}
### Prompts
FQDN=$(hostname -f 2>/dev/null || hostname 2>/dev/null)
PCOLOUR=$Magenta
# bash prompt
case $FQDN in
    *.mydeco.com) SQDN=${FQDN/.mydeco.com} ;;
    domU-*|ip-*) SQDN=$(ec2_sqdn) ;;
    *)
        if [[ -n $WINDOWID ]]; then
            PCOLOUR=$Blue; SQDN=''
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
    local hgprompt gitroot gitbranch gitstat gitstatus HGPROMPT
    [[ -d .svn ]] && { echo svn; return; }

    gitroot=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ $gitroot ]]; then
        gitbranch=$(git branch 2>/dev/null |sed -rne '/^\*/s/^\*( | master)//p')
        gitstat=$(git status 2>/dev/null | grep '\(# Untracked\|# Changes\|# Changed but not updated:\)')
        [[ $gitstat =~ 'Changes to be committed' ]] && gitstatus='!'
        [[ $gitstat =~ 'Changed but not updated' || $gitstat =~ 'Untracked files' ]] && gitstatus='?'
        echo "${Green}± ${gitroot##*/}${gitstatus:+${Red}${gitstatus}}${gitbranch:+ ${Yellow}${gitbranch}}${ANSIReset}"
        return
    fi

    HGPROMPT="${Green}☿ <root|basename><${Yellow}#<branch|quiet>><${Yellow}#<bookmark>><${Red}<status>><update>< ${Yellow}<patch>>${ANSIReset}"
    hgprompt=$(test -r /.hg || hg prompt --angle-brackets "$HGPROMPT"  2>/dev/null)
    if [[ $hgprompt ]]; then
        echo -e "$hgprompt"
        return
    fi
}

_prompt_command() {
    local shortpwd=$(_oneletter_pwd) vcs=$(_prompt_vcs) sign='\$' hc=$Green ve noescapes
    [[ $USER = root ]] && hc="$Red"
    [[ $VIRTUAL_ENV ]] && ve="${Yellow}${VIRTUAL_ENV##*/}"
    #PS1="${FaintGray}\A${ANSIReset} " # prefix time in HH:MM format
    PS1="${ve:+$ve }${vcs:+$vcs }" # virtualenv + vcs
    PS1+="${hc}${SQDN:+$SQDN:}${PCOLOUR}${shortpwd}"
    noescapes="${PS1//\\\[+([!\]])\]/}" # only useful to aprox prompt length
    (( ${#noescapes} * 2 > $COLUMNS )) && sign="\n$sign"
    PS1+="${Green}${sign}${ANSIReset} " # shorted path
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
if ! type -p mkvirtualenv >/dev/null; then
    mkvirtualenv() { virtualenv $WORKON_HOME/$1; workon $1; }
    workon () { source $WORKON_HOME/$1/bin/activate; }
    _workon() { COMPREPLY=( $(cd $WORKON_HOME; ls -d ${COMP_WORDS[1]}* 2>/dev/null) ); }
    complete -o default -o nospace -F _workon workon
    enable_system_package() {
        local src=$(/usr/bin/python -c "import os, $1 as x; print os.path.dirname(x.__file__)")
        local dst=$(python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")
        ln -sf $src $dst
    }
fi

# load system completions if available
[ -f /etc/bash_completion ] && {
    source /etc/bash_completion
    complete -F _ssh pk
}

[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
