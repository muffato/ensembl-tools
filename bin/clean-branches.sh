#!/bin/bash

[ $# -ne 2 ] && { echo "Usage: $0 remote_name branch_to_keep"; exit 1; }

git branch --remotes --no-show-current --no-verbose | grep "^  $1/" | grep -v -- " -> " | cut -d/ -f2- | grep -v "^$2$" | while read -r branch
do
    echo git push "$1" ":$branch"
done

