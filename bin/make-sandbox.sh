#! /bin/bash -i

name="sandbox_$1"
sandbox_dir="$CVS_MATT/$name"
shift

[ -e "$sandbox_dir" ] || cp -a "$CVS_MATT/.empty_sandbox" "$sandbox_dir"

for i in ensembl-webcode public-plugins ebi-plugins
do
	if [[ -e "$sandbox_dir/$i" ]]
	then
		echo "$sandbox_dir/$i already exists"
	else
		copy_git_checkout "$CVS_MATT/ensembl/$i" "$sandbox_dir/$i" "$name" "$@"
	fi
done
for i in ensembl-webcode-sandbox
do
	if [[ -e "$sandbox_dir/$i" ]]
	then
		echo "$sandbox_dir/$i already exists"
	else
		copy_git_checkout "$CVS_MATT/ensembl/$i" "$sandbox_dir/$i" "$name" matt/master
	fi
done

# First port available
seq 5080 5089 | grep -vxf <(cat $CVS_MATT/*/port) | head -n 1 > "$sandbox_dir/port"

rm -f "$sandbox_dir/ensembl-webcode/conf/Plugins.pm"
ln -s ../../ensembl-webcode-sandbox/Plugins.pm "$sandbox_dir/ensembl-webcode/conf/Plugins.pm"

