#! /bin/bash -i

release_number=$1
release_dir="${CVS_MATT}/rel$release_number"

mkdir -p "$release_dir"

for repo in $(/bin/ls "${CVS_MATT}/ensembl")
do
    if [[ -d "${CVS_MATT}/ensembl/$repo/.git" ]]
    then
	if [[ -h "$release_dir/$repo" ]]
	then
		rm "$release_dir/$repo"
	fi

	if [[ -e "$release_dir/$repo" ]]
	then
		echo "$repo already exists"
	elif [[ -e "${CVS_MATT}/ensembl/$repo/.git/refs/remotes/ensembl-github/release/$release_number" ]]
	then
		hecho "$repo"
		copy_git_checkout "${CVS_MATT}/ensembl/$repo" "$release_dir/$repo" "release/$release_number"
	else
		hecho "$repo has no release/$release_number branch"
		ln -s "../ensembl/$repo" "$release_dir/$repo"
	fi
    fi
done

[ -d "$release_dir/ensembl-webcode/conf" ] && (cd "$release_dir/ensembl-webcode/conf"; ln -sf ../../../ensembl/ensembl-webcode-sandbox/Plugins.pm)

