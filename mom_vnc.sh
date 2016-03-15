#!/usr/bin/env bash


# Check if we are home or away

count=$( ping -c 1 snorlax.dalby | grep icmp* | wc -l )


if [ $count -eq 0 ]
then
    echo "Not home"
    # Force ssh into background
    eval "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kradalby@tw.fap.no -p 21337 -L 6001:localhost:6001 -N &"
    sleep 6
else
    echo "Home"
    # Force ssh into background
    eval "ssh kradalby@snorlax.dalby -L 6001:localhost:6001 -N &"
    sleep 2
fi    


# Get pid
sshpid=$!


# Open vnc and wait for it to close
open -W vnc://localhost:6001

# kill ssh
kill $sshpid
