#!/bin/bash

if [ -z "$1" ]
then
    echo "Usage: $0 <division> <query> [<start_rel> <end_rel> <server>]"
    exit 1
fi
server=${5:-mysql-egenomes}
which "$server" > /dev/null 2> /dev/null || { echo "Server '$server' not found"; exit 1; }

for r in $(seq "${3:-86}" "${4:-105}")
do
    db="ensembl_compara_${1}_$((r-53))_${r}"
    if $server "$db" -e 'SELECT 1' > /dev/null 2> /dev/null
    then
	echo -e "\033[01;39m** $r **\033[00m"
        $server "$db" -e "$2"
    else
	echo -e "\033[01;39m** $r not found **\033[00m"
    fi
done
