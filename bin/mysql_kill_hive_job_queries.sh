#!/bin/bash

[ $# -ne 3 ] && { echo "Usage: $0 mysql-server database_name analysis_id"; exit 1; }

set -euo pipefail

"$1" -N -e 'SHOW PROCESSLIST' | awk 'BEGIN{FS="\t"} $5!="Killed" && $4=="'"$2"'" && $8 ~ /^UPDATE job.*analysis_id='"'$3'"'.*READY.*CLAIMED/ {print "KILL ", $1, ";"}' | awk 'NR%2' # | "$1"
#"$1" -N -e 'SHOW PROCESSLIST' | awk 'BEGIN{FS="\t"} $4=="'"$2"'" && $5 == "Searching rows for update" && $6 > 100 && $7 ~ /^UPDATE job SET worker_id=.*, status=.* WHERE analysis_id='"'$3'"'/ {print "KILL ", $1, ";"}' # | "$1"

