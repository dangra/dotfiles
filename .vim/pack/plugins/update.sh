#!/bin/bash

while read line; do
  row=($line)
  # Skip empty lines and comments starting with "#"
  [[ ! $row =~ ^\s*(#|$) ]] || continue
  # Get remote url and git ref to checkout
  remote=${row[0]}
  gitref=${row[1]:-origin/master}
  clonedir=sources/$(basename $remote .git)
  echo "> $remote ($gitref) into $clonedir"

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
done <${1:-SOURCES.txt}
