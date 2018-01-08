#!/bin/bash

[ $# -ne 1 ] && { echo "Usage: $0 mysql-server"; exit 1; }

set -euo pipefail

"$1" -N -e 'SHOW DATABASES LIKE "%\_test\_db\_%"' | awk '{print "DROP DATABASE "$1";"}' | "$1"

