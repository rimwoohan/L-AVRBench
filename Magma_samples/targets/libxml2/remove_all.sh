#!/bin/bash
set -e

while read -r patch; do
    name=${patch##*/}
    name=${name%.patch}
    echo "Remove $name"
	rm -rf "`pwd`/repo/$name/libxml2"
	rm -rf "`pwd`/repo/$name/out"
	rm -rf `pwd`/repo/$name/*.orig
	rm -rf `pwd`/repo/$name/*.vuln
	#rm -rf "`pwd`/repo/$name/work"
done < <(find "`pwd`/vulnerability" -name "*.patch")

echo "Remove libxml2"
rm -rf "`pwd`/repo/repo/libxml2"
rm -rf "`pwd`/repo/repo/out"
