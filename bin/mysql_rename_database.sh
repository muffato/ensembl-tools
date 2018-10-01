#!/bin/bash

[ $# -ne 3 ] && { echo "Usage: $0 mysql-server old_database_name new_database_name"; exit 1; }

set -euo pipefail

"$1" -e "CREATE DATABASE $3"
#"$1" -e "CREATE DATABASE IF NOT EXISTS $3"

echo "** $2";
echo "Backing up the views"
VIEW_DEFINITIONS=$(mktemp)
#"$1" mysqldump "$2" $("$1" "$2" --column-names=false -e "SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW'" | cut -f1) > "$VIEW_DEFINITIONS"
"$1" "$2" --column-names=false -e "SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW'" | cut -f1 | xargs --no-run-if-empty "$1" mysqldump "$2" > "$VIEW_DEFINITIONS"

"$1" "$2" --column-names=false -e "SHOW FULL TABLES WHERE TABLE_TYPE = 'BASE TABLE'" | cut -f1 | while read table; do
    echo "Moving $table"
    "$1" "$2" -e "RENAME TABLE $2.$table TO $3.$table"
done

echo "Restoring the views"
"$1" "$3" < "$VIEW_DEFINITIONS"

"$1" -e "DROP DATABASE $2"
unlink "$VIEW_DEFINITIONS"
echo "OK"
