#!/bin/bash

FORCE="$1"
SYNTAX="$2"
EXTENSION="$3"
OUTPUTDIR="$4"
INPUT="$5"
CSSFILE="$6"

FILE=$(basename "$INPUT")
FILENAME=$(basename "$INPUT" .$EXTENSION)
FILEPATH=${INPUT%$FILE}
OUTDIR=${OUTPUTDIR%$FILEPATH*}
OUTPUT="$OUTDIR"/$FILENAME
CSSFILENAME=$(basename "$6")


sed '/^tags: /d' $5 |             # remove tags line since the colons in :tag: conflict with YAML syntax 
sed 's/\(https\?\:.\+\)/<\1>/g' | # add <> around links to make them inline https://pandoc.org/MANUAL.html#automatic-links
pandoc -s --mathjax -f markdown --toc -t html --listings -c ~/dotfiles/neovim/gh-pandoc.css -o $OUTPUT.html
