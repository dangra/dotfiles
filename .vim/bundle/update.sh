#!/bin/bash

while read line; do
  row=($line)
  remote=${row[0]}
  ref=${row[1]:-master}
  dir=$(basename $remote .git)
  if [[ -d $dir ]]; then
    ( 
      cd $dir
      git fetch origin $ref --tags
      git reset --hard FETCH_HEAD
    )
  else
    git clone $remote -b $ref
  fi
done <SOURCES.txt

  
