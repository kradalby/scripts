#!/usr/bin/env bash

# Force ssh into background
eval "ssh kradalby@192.168.1.148 -L 6000:localhost:6000 -N &"

# Get pid
sshpid=$!

# Open vnc and wait for it to close
open -W vnc://localhost:6000

# kill ssh
kill $sshpid
