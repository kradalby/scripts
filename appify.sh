#!/usr/bin/env bash

# Author: Thomas Aylott

APPNAME=${2:-$(basename "$1" ".sh")}
DIR="$APPNAME.app/Contents/MacOS"
ABSPATH="$(pwd)/$1"

if [ -a "$APPNAME.app" ]; then
  echo "$PWD/$APPNAME.app already exists :("
  exit 1
fi

mkdir -p "$DIR"
#cp "$1" "$DIR/$APPNAME"
ln -s "$ABSPATH" "$DIR/$APPNAME"
chmod +x "$ABSPATH"

echo "$PWD/$APPNAME.app"
