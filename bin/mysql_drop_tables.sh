#!/bin/bash

[ $# -lt 3 ] && { echo "Usage: $0 mysql-server database_name table_name1 [table_name2 ...]"; exit 1; }

set -euo pipefail

server="$1"
shift
db="$1"
shift

for table in "$@"
do
	echo "DROP TABLE $table;"
done | "$server" "$db"
