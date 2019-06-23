#!/bin/bash

if ssh -o BatchMode=yes -o ServerAliveInterval=5 ebi-local-sync-server echo "copying in local mode"
then
    SERVER=ebi-local-sync-server
else
    SERVER=ebi-sync-server
fi
rsync -ravzH --delete "$@" ~/workspace/src/legacy/ ${SERVER}:workspace/src/legacy/
#rsync -ravzH --delete "$@" ~/workspace/src/legacy/ ${SERVER}:nfs/warehouse/muffato/src/legacy/
