#!/usr/bin/env bash

APPS="Safari iTerm Mail Messages Messenger Skype Slack Spotify Transmission"

# Stopid google with space name
open /Applications/Google\ Chrome.app

for app in $APPS
do
    open /Applications/$app.app
done
