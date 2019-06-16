#!/bin/sh

if [ -z "$1" ]
then
	echo "Usage: $0 <query_gene> [<start_rel> <end_rel> <server>]"
	exit 1
fi
gene="$1"
shift
#sql="SELECT gene_tree_root.stable_id, member_type, clusterset_id, root_id FROM gene_tree_root JOIN gene_tree_node USING (root_id) JOIN member seq_member USING (member_id) JOIN member gene_member ON gene_member.member_id = seq_member.gene_member_id WHERE ref_root_id IS NULL AND gene_member.stable_id = '$gene'"
#sql="SELECT gene_tree_root.stable_id, member_type, clusterset_id, root_id FROM gene_tree_root JOIN gene_tree_node USING (root_id) JOIN seq_member USING (seq_member_id) JOIN gene_member USING (gene_member_id) WHERE ref_root_id IS NULL AND gene_member.stable_id = '$gene'"
sql="SELECT gene_tree_root.stable_id, member_type, clusterset_id, root_id, gene_count FROM gene_tree_root JOIN gene_tree_root_attr USING (root_id) JOIN gene_tree_node USING (root_id) JOIN seq_member USING (seq_member_id) JOIN gene_member USING (gene_member_id) WHERE ref_root_id IS NULL AND gene_member.stable_id = '$gene'"

exec "$(dirname "$0")/iter_release_compara_dbs.sh" "$sql" "$@"
