#!/bin/bash
set -e
echo $(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
FILE_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CANARY_LIST="$FILE_PATH/canary-list"
# CANARY_LIST="`pwd`/canary-list"

if [[ ! -f $CANARY_LIST ]]; then
    echo "Cannot find canary-list."
    exit 1
fi
pushd "$FILE_PATH" > /dev/null
mkdir -p model_patches

while IFS= read -r CANARY_NAME || [[ -n "$CANARY_NAME" ]]; do
    if [[ -n "$CANARY_NAME" ]]; then
        mkdir -p "model_patches/$CANARY_NAME"
    fi
done < "$CANARY_LIST"
