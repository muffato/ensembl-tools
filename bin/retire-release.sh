#! /bin/bash -i

set -e

mv "rel$1" legacy

	cd "legacy/rel$1"
	rm -f reg*staging*.srl reg*mirror*srl vertannot.srl
        # Remove all symlinks
        find . -maxdepth 1 -type l -delete
	# We assume that ensembl-analysis is now out of reach
	rm -rf -- */.git
        rm -rf ensj-healthcheck/target
	for i in ensembl-analysis ensembl-taxonomy
	do
		ln -sf ../../ensembl/$i
	done
	rm -f ensembl-webcode/conf/Plugins.pm

