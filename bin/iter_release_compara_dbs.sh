#!/bin/bash

if [ -z "$1" ]
then
    echo "Usage: $0 <query> [<start_rel> <end_rel> <server>]"
    exit 1
fi
server=${4:-mysql-ensembl}
which "$server" > /dev/null 2> /dev/null || { echo "Server '$server' not found"; exit 1; }

for r in $(seq "${2:-86}" "${3:-105}")
do
    db=$(printf 'ensembl_compara_%d' "$r")
    if $server "$db" -e 'SELECT 1' > /dev/null 2> /dev/null
    then
	echo -e "\033[01;39m** $r **\033[00m"
        $server "$db" -e "$1"
    else
	echo -e "\033[01;39m** $r not found **\033[00m"
    fi
done
