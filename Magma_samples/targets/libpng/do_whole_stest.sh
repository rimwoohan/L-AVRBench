#!/bin/bash
#set -e

rm -rf canary_fail.txt

while read -r patch; do
    echo "Applying $patch"
    name=${patch##*/}
    name=${name%.patch}
    ./do_stest.sh $name

done < <(find "`pwd`/vulnerability" -name "*.patch")
