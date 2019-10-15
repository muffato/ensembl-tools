#! /bin/bash -i

set -e

mv "rel$1" legacy

	cd "legacy/rel$1"
        #rm -f *.srl
	# We assume that ensembl-analysis is now out of reach
	rm -rf -- */.git
	for i in ensembl-analysis ensembl-taxonomy
	do
		ln -sf ../../ensembl/$i
	done
	rm -f ensembl-webcode/conf/Plugins.pm

