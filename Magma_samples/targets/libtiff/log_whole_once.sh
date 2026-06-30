#!/bin/bash
#set -e

while read -r patch; do
    echo "Applying $patch"
    name=${patch##*/}
    name=${name%.patch}
    echo "==================$name====================" >> log_all_test.txt
    ./print_whole_result.sh $name >> log_all_test.txt
    echo "===========================================" >> log_all_test.txt
done < <(find "`pwd`/vulnerability" -name "*.patch")
