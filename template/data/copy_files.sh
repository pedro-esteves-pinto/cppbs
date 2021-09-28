#!/bin/bash

rm -rf $1
mkdir $1
cp -r $2/files/* $1 2>/dev/null

for filename in $1/*; do
    if [[ $filename == *.xz ]]; then
        unxz $filename
    fi
done
