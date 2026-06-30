#!/bin/bash
#set -e

while read -r patch; do
    echo "Applying $patch"
    name=${patch##*/}
    name=${name%.patch}
    echo "==================$name====================" >> log_ftest.txt
    ./print_ftest_result.sh $name >> log_ftest.txt
    echo "===========================================" >> log_ftest.txt
done < <(find "`pwd`/vulnerability" -name "*.patch")
