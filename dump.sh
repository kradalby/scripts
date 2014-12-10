#!/bin/bash

url=https://kradalby.no/dump/
path=$1
filename=`basename $path`
scp $path onyx:/srv/www/kradalby.no/dump/ > /dev/null
printf $url$filename | pbcopy
