#!/bin/bash
PLUGINSDIR=$(dirname $(readlink -f $0))
cd $PLUGINSDIR

while read line; do
  row=($line)
  # Skip empty lines and comments starting with "#"
  [[ ! $row =~ ^\s*(#|$) ]] || continue
  # Get remote url and git ref to checkout
  remote=${row[0]}
  gitref=${row[1]:-origin/master}
  clonedir=sources/$(basename $remote .git)
  echo "=> $remote ($gitref)"

  mkdir -p $clonedir
  (
    cd $clonedir
    if [[ ! -d .git ]]; then
      git init .
      git remote add origin $remote
    fi
    git fetch origin --tags
    git checkout -qf $gitref
    git clean -dfq
  )
  ln -sf ../$clonedir start/
  GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ \
    git submodule add -f $remote $clonedir
done <${1:-SOURCES.txt}
