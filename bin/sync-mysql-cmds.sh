#!/bin/bash

set -e

MY_DIR="$HOME/workspace/mysql-cmds"
SHARED_DIR="$ENSEMBL_SOFTWARE_HOME/../mysql-cmds"
for group in ensembl ensemblgenomes
do
	echo "Working on group $group"
	cd "$SHARED_DIR/$group"
	for user in *
	do
		if [[ -r $user && $user != "lib" ]]
		then
			echo "Working on user $user"
			mkdir -p "$MY_DIR/$group/$user"
			cd "$SHARED_DIR/$group/$user"
			for db in mysql-*
			do
				if [[ -r $db ]]
				then
					rm -f "$MY_DIR/$group/$user/$db"
					if [[ -L $db ]]
					then
						cp -d "$db" "$MY_DIR/$group/$user/$db"
					else
						sed "s|'/nfs/software/ensembl|\$ENV{HOME}.'/workspace|" "$db" > "$MY_DIR/$group/$user/$db"
						touch --reference "$db" "$MY_DIR/$group/$user/$db"
						chmod 750 "$MY_DIR/$group/$user/$db"
					fi
				else
					[[ -r $MY_DIR/$group/$user/$db ]] && echo "Cannot sync $group/$user/$db because the source file is not readable"
				fi
			done
			rm -f "$MY_DIR/$group/$user/mysql-treefam"-{prod,rel}*
			cd "$MY_DIR/$group/$user"
			for db in mysql-*
			do
				[[ -e "$db" && ! -e $SHARED_DIR/$group/$user/$db ]] && echo "$group/$user/$db has disappeared upstream"
			done
			cd "$SHARED_DIR/$group"
		fi
	done
done

