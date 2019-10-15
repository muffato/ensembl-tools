#!/bin/bash

set -euo pipefail

update_registry () {
	hecho "$2"
	"$(dirname "$0")/registry_db_cmd.pl" "$1" "$2" _
	echo
}

update_registry live ensembl
update_registry live egenomes
update_registry mirror ebimirror
update_registry mirror egmirror
update_registry staging staging
update_registry staging eg_staging

for rel in $(seq 95 110)
do
	update_registry "rel$rel" ensembl
	update_registry "rel$rel" egenomes
done
