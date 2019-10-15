#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 checkout_name"; exit 1; }

rel="$1"
shift

# Automatically switch to the legacy sub-dir
if [ -e "$CVS_MATT/legacy/$rel" ]
then
    rel="legacy/$rel"
fi

if [ ! -e "$CVS_MATT/$rel/ensembl/modules/Bio/EnsEMBL/Registry.pm" ]
then
    echo "API version $rel doesn't exist !"
    exit 1
fi

# This partly duplicates what modules do, but it is more efficient
env PERL5LIB="$CVS_MATT/$rel/ensembl/modules:$CVS_MATT/ensembl/ensembl-compara/modules:$PERL5LIB" ENSEMBL_CVS_ROOT_DIR="$CVS_MATT/$rel" "$(dirname "$0")/registry_db_cmd.pl" "$@"
