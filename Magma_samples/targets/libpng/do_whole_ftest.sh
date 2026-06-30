#!/bin/bash
#set -e

while read -r patch; do
    echo "Applying $patch"
    name=${patch##*/}
    name=${name%.patch}
    ./do_ftest.sh $name
    
done < <(find "`pwd`/vulnerability" -name "*.patch")
