#!/bin/bash

for i in $(bhosts -w | awk '{print $1}' | tail -n+2)
do
    #hecho $i
    echo -e "\033[01;39m${i}\033[00m"
    timeout 1m ssh $i -o BatchMode=yes -o ServerAliveInterval=30 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null bash ~/workspace/ensembl-tools/bin/cleanonetmp.sh
done 2> /dev/null 
