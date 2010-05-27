#!/bin/bash
#
# call with dina5_book file.pdf
set -e

file=$1
filebase=$(basename $file .pdf)
pdftops $file output.ps
#psbook output.ps tmp.ps
ln -sf output.ps tmp.ps
#pstops -pa4 "4:0L@.7(21cm,0)+1L@.7(21cm,14.85cm),2R@.7(0,29.7cm)+3R@.7(0,14.85cm)" tmp.ps > ${filebase}-booklet.ps
#pstops -pa4 "4:0L@.7(21cm,0)+1L@.7(21cm,14.85cm),2R@.7(0,29.7cm)+3R@.7(0,14.85cm)" tmp.ps > ${filebase}-booklet.ps
pstops "4:0L@.7(21cm,0)+1L@.7(21cm,13.95cm),2L@.7(0,27.9cm)+3L@.7(0,13.95cm)" tmp.ps > ${filebase}-booklet.ps
rm -f output.ps tmp.ps
echo "Converting back to pdf ..."
ps2pdf -dCompatibilityLevel=1.6 ${filebase}-booklet.ps
rm -f ${filebase}-booklet.ps
