#!/bin/bash
#set -e

CVE_LIST="`pwd`/cve-list"

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        echo "==================$CVE_NAME====================" >> log_ftest.txt
        ./print_ftest_result.sh $CVE_NAME >> log_ftest.txt
        echo "=======================================================" >> log_ftest.txt
    fi
done < "$CVE_LIST"

