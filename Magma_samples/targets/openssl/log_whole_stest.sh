#!/bin/bash
#set -e

while read -r patch; do
    echo "Applying $patch"
    name=${patch##*/}
    name=${name%.patch}
    echo "==================$name====================" >> log_stest.txt
    ./print_stest_result.sh $name >> log_stest.txt
    echo "===========================================" >> log_stest.txt
done < <(find "`pwd`/vulnerability" -name "*.patch")
