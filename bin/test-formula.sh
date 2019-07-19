#!/bin/bash

set -e

tempdir=$(mktemp -d)
filename=$(basename "$1")
cp -a "$1" "$tempdir"

MOONSHINE_NAME=ENSEMBL_MOONSHINE_ARCHIVE
MOONSHINE_PATH_LOCAL=$CVS_MATT/brew/$MOONSHINE_NAME
MOONSHINE_PATH_DOCKER=/home/linuxbrew/$MOONSHINE_NAME

docker run -it \
    -v "$MOONSHINE_PATH_LOCAL:$MOONSHINE_PATH_DOCKER" \
    -v "${tempdir}:${tempdir}" \
    --env HOMEBREW_NO_AUTO_UPDATE=1 \
    muffato/ensembl-linuxbrew-basic-dependencies \
    brew install --build-from-source "$tempdir/$filename"

rm -rf "$tempdir"

