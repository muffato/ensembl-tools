#!/bin/bash

# NOTE: expected to be in $MODULEPATH
MYMODULEDIR=$HOME/workspace/src/.modules

# Ensembl API
rm -rf "$MYMODULEDIR/ensembl"
mkdir -p "$MYMODULEDIR/ensembl/legacy/"
cd "$CVS_MATT/legacy/"
for _i in rel*
do
	ln -s ../../.template_ensembl "$MYMODULEDIR/ensembl/legacy/$_i"
done
cd "$CVS_MATT"
for _i in *
do
	[ -d "$_i" ] && [ -e "$_i/ensembl-compara" ] && ln -s ../.template_ensembl "$MYMODULEDIR/ensembl/$_i"
	[ -L "$_i" ] && [ ! -d "$_i" ] && ln -s ../.template_ensembl "$MYMODULEDIR/ensembl/$_i"
done
echo -e "#%Module\nset ModulesVersion \"ensembl\"" > "$MYMODULEDIR/ensembl/.version"
touch -r "$MYMODULEDIR/.template_ensembl" "$MYMODULEDIR/ensembl/.version"

# eHive
rm -rf "$MYMODULEDIR/hive"
mkdir -p "$MYMODULEDIR/hive/schema/"
cd "$CVS_MATT/hive/schema/"
for _i in *
do
	ln -s ../../.template_hive "$MYMODULEDIR/hive/schema/$_i"
done
cd "$CVS_MATT/hive"
for _i in *
do
	[ -d "$_i" ] && [ -e "$_i/modules" ] && ln -s ../.template_hive "$MYMODULEDIR/hive/$_i"
done
echo -e "#%Module\nset ModulesVersion \"master\"" > "$MYMODULEDIR/hive/.version"
touch -r "$MYMODULEDIR/.template_hive" "$MYMODULEDIR/hive/.version"
