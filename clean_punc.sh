#!/bin/bash

if [ "$1" == "" ]; then
  RMDFILE=*.Rmd
else
  RMDFILE=$1
fi

sed -i -e 's/。/./g' -e 's/，/,/g' -e 's/！/!/g' -e 's/：/:/g' -e 's/）/)/g' \
 -e 's/？/?/g' -e 's/”/"/g' -e 's/…/.../g' -e "s/’/'/g" -e "s/‘/'/g" -e "s/≥/>=/g" \
 -e "s/－/-/g" -e "s/［/[/g" -e "s/］/]/g" -e 's/“/"/g' -e 's/【/[/g' -e 's/】/]/g' \
 -e 's/『//g' -e 's/』//g' $RMDFILE

