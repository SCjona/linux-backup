#!/bin/bash

mkdir -p sources
mkdir -p destination
mkdir -p keyfiles
if [ ! -f "keyfiles/fallback" ]; then
    echo "No fallback key found, generated one. Please back it up!"
    uuidgen > keyfiles/fallback
fi
