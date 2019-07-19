#!/bin/bash

set -eu

if [ -z "$1" ]
then
	echo 'Usage: $0 <name_of_perl_env>'
	exit 1
fi

rm -rf "$HOME/src/local/perl/$1"
curl -L http://cpanmin.us | perl - App::cpanminus

