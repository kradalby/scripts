#!/bin/bash

# Use this as a osx service.
# Edit for own needs.
# 
# Install:
# Open Automater.app
# Create Service
# Change to no input and add Run Shell Script
# Paste path to script ( make sure it is executable )
# Save and add a shortcut to it under System Preferences > Keyboard > Shortcuts

url=https://kradalby.no/pb/
filename=`date '+%Y%m%d%H%M%S'`.txt

for f in "$@"
do
    echo $f + "\n" >> ~/derp8
done

echo $@ | /usr/local/bin/ssh onyx "cat > /srv/www/kradalby.no/pb/$filename"
printf $url$filename | pbcopy
