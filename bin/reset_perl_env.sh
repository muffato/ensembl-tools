#!/bin/bash

set -e

if [ -z "$PERL_BIN_ENV" ]
then
	echo '$PERL_BIN_ENV not set'
	exit 1
fi

rm -rf "$HOME/src/local/perl/$PERL_BIN_ENV"
curl -L http://cpanmin.us | perl - App::cpanminus

