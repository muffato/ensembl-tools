#!/bin/bash
rsync -ravH --exclude legacy --exclude split_genes --exclude blast --exclude git-stats --exclude treebest --exclude treebest_notung --delete "$@" ~/workspace/ sanger-unison-server:/nfs/users/nfs_m/mm14/workspace/
#rsync -ravH --delete "$@" ~/workspace/src/legacy/ ebi-sync-server:workspace/src/legacy/
#rsync -ravH --delete "$@" ~/workspace/src/legacy/ ebi-sync-server:nfs/warehouse/muffato/src/legacy
