#!/bin/bash

URL=''
for j in mysql-ens-compara-prod-1 mysql-ens-compara-prod-2 mysql-ens-compara-prod-3 mysql-ens-compara-prod-4 mysql-ens-compara-prod-5 mysql-ens-compara-prod-6 mysql-ens-compara-prod-7 mysql-ens-compara-prod-8 mysql-ens-compara-prod-9 mysql-ens-compara-prod-10
do
    for i in $("$j" -N <<< "SHOW DATABASES LIKE '$1'")
    do
        if $j "$i" -e 'SELECT 1 FROM job LIMIT 1' > /dev/null 2> /dev/null
        then
            URL="$URL --url $($j details url "$i")"
        fi
    done
done
echo "$URL"

