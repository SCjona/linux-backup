#!/bin/bash

cd "$(dirname "$0")"

mkdir -p sources
mkdir -p destination
mkdir -p keyfiles
if [ ! -f "keyfiles/fallback" ]; then
    echo "No fallback key found, generated one. Please back it up!"
    uuidgen > keyfiles/fallback
fi
if [ ! -f "download.sh" ]; then
    cp default-download.sh download.sh
fi
if [ ! -f "upload.sh" ]; then
    cp default-upload.sh upload.sh
fi
