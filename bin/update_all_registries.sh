#!/bin/bash -i

set -euo pipefail

update_registry () {
	hecho "$1/$2"
	# This partly duplicates what modules do, but it is more efficient
	env PERL5LIB="$CVS_MATT/$1/ensembl/modules:$CVS_MATT/ensembl/ensembl-compara/modules:$PERL5LIB" ENSEMBL_CVS_ROOT_DIR="$CVS_MATT/$1" "$(dirname "$0")/registry_db_cmd.pl" "$2" _
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
