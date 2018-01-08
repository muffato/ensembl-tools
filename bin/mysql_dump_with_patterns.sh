#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 mysql-server database_name [table_names] [- [table_names]]"; exit 1; }

set -euo pipefail

server=$1
db=$2
shift
shift

del=0
for i in "$@"
do
	if [[ $i == "-" ]]
	then
		del=1
	else
		"$server" "$db" -N -e "SHOW TABLES LIKE '$i'" | if [[ $del == 1 ]]; then awk '{print "--ignore-table='"$db"'."$1}'; else cat; fi
	fi
done | xargs "$server" mysqldump "$db"

