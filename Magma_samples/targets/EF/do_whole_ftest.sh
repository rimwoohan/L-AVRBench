#!/bin/bash
#set -e

CVE_LIST="`pwd`/cve-list"

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        ./do_ftest.sh $CVE_NAME
    fi
done < "$CVE_LIST"

