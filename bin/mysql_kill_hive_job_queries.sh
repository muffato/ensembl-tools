#!/bin/bash

[ $# -ne 3 ] && { echo "Usage: $0 mysql-server database_name analysis_id"; exit 1; }

set -euo pipefail

"$1" -N -e 'SHOW PROCESSLIST' | awk 'BEGIN{FS="\t"} $4=="'"$2"'" && $5 == "Searching rows for update" && $6 > 100 && $7 ~ /^UPDATE job SET worker_id=.*, status=.* WHERE analysis_id='"'$3'"'/ {print "KILL ", $1, ";"}' | "$1"

