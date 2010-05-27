#!/bin/bash
bckdir=${1:-/tmp}
bckname=$USER-$(date +%FT%H%M%S)
homedir=$HOME

# backup dot files
mkdir -p "$bckdir/$bckname"
tar \
	--exclude $homedir/[^.]\* \
	--exclude $homedir/.cache \
	--exclude $homedir/.tmp \
	--exclude $homedir/\*/[Cc]ache/\* \
	--exclude $homedir/.thumbnails \
	--one-file-system \
	--exclude-vcs \
	-zvcf "$bckdir/$bckname/dotfiles.tgz" \
	"$homedir"

# backup Documents Photos and Videos
for d in Documents Photos Videos; do
	tar -vcf "$bckdir/$bckname/$d.tar" "$homedir/$d"
done
