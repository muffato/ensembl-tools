#!/bin/bash

[ $# -ne 2 ] && { echo "Usage: $0 mysql-server database_name"; exit 1; }

set -euo pipefail

"$1" "$2" -N -e 'SHOW TABLES LIKE "peptide_align_feature_%"' | awk '{print "DROP TABLE "$1";"}' | "$1" "$2"

