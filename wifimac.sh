#!/bin/bash

# This script will change the powerstate of the wlan adapter on a mac.
# Change the interface to what you mac uses.
# I use it togheter with BetterTouchTools

int=en0
int_status=$(networksetup -getairportpower $int)

if [ "$int_status" == "Wi-Fi Power ($int): On" ]; then
    networksetup -setairportpower $int off
else
    networksetup -setairportpower $int on
fi
