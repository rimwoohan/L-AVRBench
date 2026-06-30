#!/bin/bash
#set -e

CVE_LIST="`pwd`/cve-list"

if [[ ! -f $CVE_LIST ]]; then
    echo "Cannot find cve-list."
    exit 1
fi

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        pushd "`pwd`/repo/$CVE_NAME" > /dev/null
            "./fetch.sh"
            if [ $? -ne 0 ]; then
                echo "ERROR : There is some error in fetching project."
                exit 22
            fi

            "./config.sh"
            if [ $? -ne 0 ]; then
                echo "ERROR : There is some error in configuration"
                exit 22
            fi
        popd > /dev/null
    fi
done < "$CVE_LIST"

echo "fetch complete."
