#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 mysql-server database_name1 [database_name2 ...]"; exit 1; }

set -euo pipefail

server="$1"
shift

for db in "$@"
do
	echo "DROP DATABASE $db;"
done | "$server"
