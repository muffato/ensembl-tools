#!/bin/bash

if [ $# -lt 2 ]
then
	echo "Usage: $0 <release_number> <query> [<server>]"
        exit 1
fi
server=${3:-mysql-ensembl}
for db in $($server -A -N -e "SHOW DATABASES LIKE '%\_core\_$1\_%'")
do
	echo -e "\033[01;39m** $db **\033[00m"
	$server "$db" -ANs -e "$2"
done
