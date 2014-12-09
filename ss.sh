#!/bin/bash

url=https://kradalby.no/ss/
filename=ss_`date '+%Y%m%d%H%M%S'`.png
path=~/Pictures/ss/
mkdir -p $path
screencapture -o -i $path$filename
scp $path$filename onyx:/srv/www/kradalby.no/ss/ > /dev/null
printf $url$filename | pbcopy
