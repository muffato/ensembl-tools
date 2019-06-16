#!/bin/sh

if [ -z "$1" ]
then
	echo "Usage: $0 <query_gene> [<start_rel> <end_rel> <server>]"
	exit 1
fi
gene="$1"
shift
#sql="SELECT homology_id, homology.description, gm1.stable_id, gm1.display_label, hm1.perc_id, gm2.stable_id, gm2.display_label, hm2.perc_id FROM homology JOIN (homology_member hm1 JOIN gene_member gm1 USING (gene_member_id)) USING (homology_id) JOIN (homology_member hm2 JOIN gene_member gm2 USING (gene_member_id)) USING (homology_id) WHERE gm1.stable_id = '$gene' AND hm1.gene_member_id != hm2.gene_member_id AND gm2.genome_db_id = gm1.genome_db_id"
sql="SELECT homology_id, homology.description, is_tree_compliant, dn, ds, goc_score, wga_coverage, is_high_confidence, gm1.stable_id, gm1.display_label, hm1.perc_id, gm2.stable_id, gm2.display_label, hm2.perc_id FROM homology JOIN (homology_member hm1 JOIN gene_member gm1 USING (gene_member_id)) USING (homology_id) JOIN (homology_member hm2 JOIN gene_member gm2 USING (gene_member_id)) USING (homology_id) WHERE gm1.stable_id = '$gene' AND hm1.gene_member_id != hm2.gene_member_id AND gm2.genome_db_id = gm1.genome_db_id"

exec "$(dirname "$0")/iter_release_compara_dbs.sh" "$sql" "$@"
