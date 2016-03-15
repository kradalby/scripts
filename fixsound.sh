#!/usr/bin/env bash

# This script is for reloading the sounddrivers on my macbook pro

sudo kextunload /System/Library/Extensions/AppleHDA.kext
sudo kextload /System/Library/Extensions/AppleHDA.kext

#sudo killall coreaudiod


