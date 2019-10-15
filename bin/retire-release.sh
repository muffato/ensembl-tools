#! /bin/bash -i

set -e

mv "rel$1" legacy

	cd "legacy/rel$1"
	rm -f reg*staging*.srl reg*mirror*srl vertannot.srl
	rm -f ensembl-analysis ensembl-taxonomy ensembl-vep
	# We assume that ensembl-analysis is now out of reach
	rm -rf -- */.git
	for i in ensembl-analysis ensembl-taxonomy ensembl-vep
	do
		ln -sf ../../ensembl/$i
	done
	rm -f ensembl-webcode/conf/Plugins.pm

