#!/bin/bash
set -e

CVE_LIST="`pwd`/cve-list"

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        pushd "`pwd`/repo/$CVE_NAME" > /dev/null
            rm -rf "`pwd`/$CVE_NAME"
            rm -rf "`pwd`/out"
            rm -rf "`pwd`/dev-patch"
            rm -rf "`pwd`/xaaa.tif"
            rm -rf `pwd`/*.orig
            rm -rf `pwd`/*.vuln
        popd > /dev/null
    fi
done < "$CVE_LIST"

echo "remove complete."

