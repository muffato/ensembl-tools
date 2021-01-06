#!/bin/bash -i

while read -r server dbname
do
    hecho $server $dbname
    $server $dbname "$@"
done


