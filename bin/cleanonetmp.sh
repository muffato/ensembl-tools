#!/bin/bash

ls -d {/tmp,/scratch}/worker_muffato*

## Make a backup
#mkdir -p "$HOME/nfs/hps/muffato/tmp/$HOSTNAME"
#ls /scratch | grep "^worker_muffato" | while read -r d; do mv "/scratch/$d" "$HOME/nfs/hps/muffato/tmp/${d//worker/$HOSTNAME/worker}"; done

rm -rf {/tmp,/scratch}/worker_muffato*

[ -d /tmp/hsperfdata_muffato ] && rmdir /tmp/hsperfdata_muffato

