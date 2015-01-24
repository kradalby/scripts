#!/bin/bash

url=https://kradalby.no/dump/
path=$1
filename=`basename $path`
/usr/local/bin/scp $path onyx:/srv/www/kradalby.no/dump/ > /dev/null
printf $url$filename | pbcopy
