#!/bin/bash
#set -e

while read -r patch; do
    echo "Applying $patch"
    name=${patch##*/}
    name=${name%.patch}
    echo "==================$name====================" >> log_compile.txt
    ./print_compile_result.sh $name >> log_compile.txt
    echo "===========================================" >> log_compile.txt
done < <(find "`pwd`/vulnerability" -name "*.patch")
