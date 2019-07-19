#!/bin/bash

set -e

tempdir=$(mktemp -d)
filename=$(basename "$1")
cp -a "$1" "$tempdir"

docker run -it \
    -v "${tempdir}:${tempdir}" \
    --env HOMEBREW_NO_AUTO_UPDATE=1 \
    muffato/ensembl-linuxbrew-basic-dependencies \
    brew install --build-from-source "$tempdir/$filename"

rm -rf "$tempdir"

