#!/bin/bash
#set -e

CVE_LIST="`pwd`/cve-list"

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        echo "==================$CVE_NAME====================" >> log_all_test.txt
        ./print_whole_result.sh $CVE_NAME >> log_all_test.txt
        echo "=======================================================" >> log_all_test.txt
    fi
done < "$CVE_LIST"

