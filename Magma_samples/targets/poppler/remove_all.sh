#!/bin/bash
set -e

while read -r patch; do
    name=${patch##*/}
    name=${name%.patch}
    echo "Remove $name"
	rm -rf "`pwd`/repo/$name/poppler"
	rm -rf "`pwd`/repo/$name/freetype2"
	rm -rf "`pwd`/repo/$name/out"
	rm -rf "`pwd`/repo/$name/work"
	rm -rf `pwd`/repo/$name/*.ppm
	rm -rf `pwd`/repo/$name/*.pbm
	rm -rf `pwd`/repo/$name/*.orig
	rm -rf `pwd`/repo/$name/*.vuln

done < <(find "`pwd`/vulnerability" -name "*.patch")

echo "Remove poppler"
rm -rf "`pwd`/repo/repo/poppler"
rm -rf "`pwd`/repo/repo/freetype2"
rm -rf "`pwd`/repo/repo/out"
rm -rf "`pwd`/repo/repo/work"
rm -rf "`pwd`/repo/repo/test"
