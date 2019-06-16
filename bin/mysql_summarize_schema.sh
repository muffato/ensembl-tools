#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 mysql-server [database_name] [table_name1] ... [table_nameN]"; exit 1; }

set -euo pipefail

db="$1"
shift
"$db" mysqldump "$@" | awk 'BEGIN{n=0} $1=="INSERT" {last=$1" "$2" "$3;n++} $1!="INSERT" && n>0 {print n " x " last; n=0} $0 ~ /^(DROP|CREATE|-- Host:)/ {print}'

