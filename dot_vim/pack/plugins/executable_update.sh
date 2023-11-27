#!/bin/bash
# vim:ft=sh:expandtab:ts=2
PLUGINSDIR=$(dirname $(readlink -f $0))
cd $PLUGINSDIR

dotgit() {
  GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ git "$@"
}

while read line; do
  # Skip empty lines and comments starting with "#"
  [[ ! $line =~ ^\s*(#|$) ]] || continue

  # Get remote url and git ref to checkout
  row=($line)
  remote=${row[0]}
  gitref=${row[1]}
  clonedir=sources/$(basename $remote .git)
  echo "=> $remote (${gitref:-default})"

  if [[ ! -d $clonedir ]]; then
    git clone $remote $clonedir
    [[ -z $gitref ]] || ( pushd $clonedir && git reset --hard $gitref )
  elif [[ -n $gitref ]]; then
    pushd $clonedir
    git fetch
    git reset --hard $gitref
    popd
  else
    pushd $clonedir
    git stash && git pull --rebase #&& git stash --apply
    popd
  fi
  ln -sf ../$clonedir start/

done <${1:-SOURCES.txt}
