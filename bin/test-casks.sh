#!/bin/bash

set -e

mounts=''
for d in cask ensembl external moonshine web
do
    mounts="$mounts -v $CVS_MATT/brew/homebrew-$d:/home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/ensembl/homebrew-$d"
done
exec docker run -it $mounts muffato/ensembl-linuxbrew-basic-dependencies

