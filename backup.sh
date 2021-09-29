#!/bin/bash

set -e

cd "$(dirname "$0")"

echo "Downloading remote hashes"
./download.sh hashes.txt remote_hashes.txt || touch remote_hashes.txt

cd sources
# clean up old
rm *.tar* || echo "Last run was without fault"

for source in *; do
    echo "Checking $source"

    if echo "$source" | grep -Pv '^[a-zA-Z0-9-_]+$'; then
        echo "Backup name '$source' is INVALID. Allowed charset: a-zA-Z0-9-_"
        ../notify.sh "Backup name '$source' is INVALID. Allowed charset: a-zA-Z0-9-_"
        continue
    fi

    # collect files
    tar --exclude-caches -cf "$source.tar" "$source/."
    # calculate / load hashes
    LOCAL_HASH="$(sha512sum -b "$source".tar | cut -d ' ' -f 1)"
    REMOTE_HASH="$(cat ../remote_hashes.txt | grep -P -- "^$source=[0-9a-fA-F]+$" | cut -d '=' -f 2)"

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "Hash for $source differs... Uploading new version"

        # remove old hash
        echo "Removing old hash"
        grep -Pv "^$source=[0-9a-fA-F]+$" ../remote_hashes.txt > ../remote_hashes_new.txt || echo "Nothing to remove"
        mv ../remote_hashes_new.txt ../remote_hashes.txt

        # Compress
        echo "Compressing"
        time xz -z -T0 "$source.tar"
        # Encrypt
        echo "Encrypting"
        KEYFILE="../keyfiles/$source.keyfile"
        if [ ! -f "$KEYFILE" ]; then
            echo "No keyfile for $source found. Using fallback keyfile..."
            KEYFILE="../keyfiles/fallback"
        fi
        time openssl aes-256-cbc -e -in "$source.tar.xz" -out "$source.tar.xz.bin" -kfile "$KEYFILE" -pbkdf2 -iter 1500000
        rm "$source.tar.xz"

        # Uploading new file
        ../upload.sh "$source.tar.xz.bin" "$source.tar.xz.bin"

        # add new hash
        echo "Adding new hash"
        echo "$source=$LOCAL_HASH" >> ../remote_hashes.txt
    fi
done

cd ..

echo "Uploading (updated) remote hashes"
./upload.sh remote_hashes.txt hashes.txt

echo "Done!"
