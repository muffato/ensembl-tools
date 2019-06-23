#! /bin/bash -i

release_number=$1
release_dir=rel$release_number

[[ -e "$release_dir" ]] || cp -a "${CVS_MATT}/.empty_release/" "$release_dir"

for repo in ensembl ensembl-compara ensembl-funcgen ensembl-variation ensembl-io ensembl-metadata ensembl-test ensj-healthcheck ensembl-production ensembl-rest ensembl-webcode public-plugins ensembl-tools ensembl-orm
do
	if [[ -h "$release_dir/$repo" ]]
	then
		rm "$release_dir/$repo"
	fi

	if [[ -e "$release_dir/$repo" ]]
	then
		echo "$release_dir/$repo already exists"
	elif [[ -e "${CVS_MATT}/ensembl/$repo/.git/refs/remotes/ensembl-github/release/$release_number" ]]
	then
		hecho "$repo"
		copy_git_checkout "${CVS_MATT}/ensembl/$repo" "$release_dir/$repo" "release/$release_number"
	else
		hecho "$release_dir/$repo has no release/$release_number branch"
		ln -s "../ensembl/$repo" "$release_dir/$repo"
	fi
done

[ -d "$release_dir/ensembl-webcode/conf" ] && (cd "$release_dir/ensembl-webcode/conf"; ln -sf ../../../ensembl/ensembl-webcode-sandbox/Plugins.pm)

