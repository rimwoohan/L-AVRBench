#!/bin/bash
set -e

while read -r patch; do
    name=${patch##*/}
    name=${name%.patch}
    echo "Remove test_result of $name"
	rm -rf "`pwd`/repo/$name/test_result"
done < <(find "`pwd`/vulnerability" -name "*.patch")

