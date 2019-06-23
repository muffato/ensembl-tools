#!/bin/bash -i

while read -r server dbname
do
    "${server}-ensadmin" drop $dbname
done


