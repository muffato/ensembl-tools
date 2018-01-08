#!/bin/bash

[ $# -ne 2 ] && { echo "Usage: $0 mysql-server database_name"; exit 1; }

set -euo pipefail

"$1" -N -e "SELECT table_name AS 'Tables',  TABLE_ROWS, round(((data_length + index_length) / 1024 / 1024), 2) AS 'Size in MB' FROM information_schema.TABLES WHERE table_schema = '$2' ORDER BY (data_length + index_length) DESC"

