#!/bin/bash

if [ $# -lt 2 ]
then
	echo "Usage: $0 <release_number> <query> [<server>]"
	exit 1
fi
server=${3:-mysql-ensembl}
for db in $($server -A -N -e "SHOW DATABASES LIKE '%\_core\_$1\_%'")
do
	$server "$db" -ANs -e "$2" | sed "s/$/\t$(sed 's/_core_.*//' <<< "$db")/"
done
