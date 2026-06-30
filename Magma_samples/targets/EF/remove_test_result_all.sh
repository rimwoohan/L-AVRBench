#!/bin/bash
set -e

CVE_LIST="`pwd`/cve-list"

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        pushd "`pwd`/repo/$CVE_NAME" > /dev/null
            rm -rf "`pwd`/test_result"
        popd > /dev/null
    fi
done < "$CVE_LIST"

