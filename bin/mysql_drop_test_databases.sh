#!/bin/bash

[ $# -gt 2 -o $# -lt 1 ] && { echo "Usage: $0 mysql-server [username]"; exit 1; }

set -euo pipefail

username=${2:-$USER}

"$1" -N -e "SHOW DATABASES LIKE '$username\_test\_db\_%'" | awk '{print "DROP DATABASE "$1";"}' | "$1"

