#!/bin/bash

while read line; do
  echo $line
  row=($line)
  remote=${row[0]}
  ref=${row[1]:-master}
  dir=$(basename $remote .git)
  [[ -d $dir ]] || mkdir $dir
  (
    cd $dir
    if [[ ! -d .git ]]; then
      git init .
      git remote add origin $remote
    fi
    git fetch origin master --tags
    git reset --hard $ref
  )
done <SOURCES.txt
