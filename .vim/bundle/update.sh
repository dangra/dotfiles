#!/bin/bash

while read line; do
  echo $line
  row=($line)
  [[ $row ]] || continue
  remote=${row[0]}
  ref=${row[1]:-origin/master}
  dir=$(basename $remote .git)
  [[ -d $dir ]] || mkdir $dir
  (
    cd $dir
    if [[ ! -d .git ]]; then
      git init .
      git remote add origin $remote
    fi
    git fetch origin --tags
    git checkout -qf $ref
  )
done <${1:-SOURCES.txt}
