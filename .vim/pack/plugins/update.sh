#!/bin/bash
PLUGINSDIR=$(dirname $(readlink -f $0))
cd $PLUGINSDIR

dotgit() {
  GIT_DIR=~/.dotfiles.git GIT_WORK_TREE=~ git "$@"
}

while read line; do
  row=($line)
  # Skip empty lines and comments starting with "#"
  [[ ! $row =~ ^\s*(#|$) ]] || continue
  # Get remote url and git ref to checkout
  remote=${row[0]}
  gitref=${row[1]}
  clonedir=sources/$(basename $remote .git)
  echo "=> $remote (${gitref:-default})"

  #mkdir -p $clonedir
  # (
  #   cd $clonedir
  #   if [[ ! -d .git ]]; then
  #     git init .
  #     git remote add origin $remote
  #   fi
  #   git fetch origin --tags
  #   git checkout -qf $gitref
  #   git clean -dfq
  # )
  ln -sf ../$clonedir start/
  dotgit submodule add -f ${gitref:+--branch $gitref} -- $remote $clonedir
  #dotgit submodule init -- $clonedir
  dotgit submodule update --rebase -- $clonedir
done <${1:-SOURCES.txt}
