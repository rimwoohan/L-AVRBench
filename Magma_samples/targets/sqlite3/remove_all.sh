#!/bin/bash
set -e

while read -r patch; do
    name=${patch##*/}
    name=${name%.patch}
    echo "Remove $name"
	rm -rf "`pwd`/repo/$name/sqlite3"
	rm -rf "`pwd`/repo/$name/out"
	rm -rf "`pwd`/repo/$name/work"
	rm -rf `pwd`/repo/$name/*.orig
	rm -rf `pwd`/repo/$name/*.vuln
done < <(find "`pwd`/vulnerability" -name "*.patch")

echo "Remove sqlite3"
rm -rf "`pwd`/repo/repo/sqlite3"
rm -rf "`pwd`/repo/repo/out"
rm -rf "`pwd`/repo/repo/work"
