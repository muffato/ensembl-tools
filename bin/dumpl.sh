#!/bin/bash -i

while read -r server dbname
do
    bsub.mem3 800 dump.sh "${server}-ensadmin" $dbname
done


