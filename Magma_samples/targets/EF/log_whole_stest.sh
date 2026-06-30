#!/bin/bash
#set -e

CVE_LIST="`pwd`/cve-list"

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        echo "==================$CVE_NAME====================" >> log_stest.txt
        ./print_stest_result.sh $CVE_NAME >> log_stest.txt
        echo "=======================================================" >> log_stest.txt
    fi
done < "$CVE_LIST"

