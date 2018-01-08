#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 mysql-server [database_name] [table_name1] ... [table_nameN]"; exit 1; }

set -euo pipefail

db="$1"
shift
"$db" mysqldump "$@" --no-data --skip-add-drop-table | sed 's/ AUTO_INCREMENT=[0-9]*//' | grep -v '^-- Host: .*Database: ' | grep -v -- '^-- Dump completed on' | sed 's/latin1_swedish_ci/utf8_general_ci/g' | sed 's/latin1/utf8/g'

