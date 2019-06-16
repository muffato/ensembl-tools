#!/bin/bash

if [ -z "$2" ]
then
    echo "Usage: $0 <release_number> <query>"
    exit 1
fi
rel=$1
shift
for db in $(mysql-egenomes -A -N -e "SHOW DATABASES LIKE '%compara%$rel'")
do
    echo -e "\033[01;39m** $db **\033[00m"
    mysql-egenomes "$db" -ANs -e "$@"
done

