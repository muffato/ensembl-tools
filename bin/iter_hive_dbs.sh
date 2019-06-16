#!/bin/bash

for j in mysql-ens-compara-prod-1 mysql-ens-compara-prod-2 mysql-ens-compara-prod-3 mysql-ens-compara-prod-4 mysql-ens-compara-prod-5 mysql-ens-compara-prod-6 mysql-ens-compara-prod-7 mysql-ens-compara-prod-8
do
    for i in $("$j" -N <<< 'SHOW DATABASES')
    do
        if $j "$i" -e 'SELECT 1 FROM job LIMIT 1' > /dev/null 2> /dev/null
        then
            $j "$i" -ANsqe "$@" | sed "s|^|$j\t$i\t|"
        fi
    done
done

