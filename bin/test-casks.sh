#!/bin/bash

set -eu

MOONSHINE_NAME=ENSEMBL_MOONSHINE_ARCHIVE
MOONSHINE_PATH_LOCAL=$CVS_MATT/brew/$MOONSHINE_NAME
MOONSHINE_PATH_DOCKER=/home/linuxbrew/$MOONSHINE_NAME
mounts="-v $MOONSHINE_PATH_LOCAL:$MOONSHINE_PATH_DOCKER"

for d in cask ensembl external moonshine web
do
    mounts="$mounts -v $CVS_MATT/brew/homebrew-$d:/home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/ensembl/homebrew-$d"
done
exec docker run -it $mounts muffato/ensembl-linuxbrew-basic-dependencies

