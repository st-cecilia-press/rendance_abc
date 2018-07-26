#!/bin/bash

#SECTIONS="basse_dance 15italian gresley inns 16italian arbeau improvised playford playford_later other"
SECTIONS="basse_dance 15italian gresley inns 16italian arbeau playford playford_later other"

for section in $SECTIONS; do
  echo "converting $section"
  iconv -f iso-8859-1 -t utf-8 $section.abc  | ruby abc2latex.rb latex_$section  > build/$section.tex;
done

#for section in $SECTIONS; do
#  latex -shell-escape $section.tex
#  latex -shell-escape $section.tex
#  dvipdf $section.dvi
#done
