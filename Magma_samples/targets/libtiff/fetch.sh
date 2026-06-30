#!/bin/bash
set -e

sudo apt-get update && \
    sudo apt-get install -y git make autoconf automake libtool cmake nasm \
        zlib1g-dev liblzma-dev libjpeg-turbo8-dev wget

mkdir -p "`pwd`/repo/repo/libtiff"

git clone --no-checkout https://gitlab.com/libtiff/libtiff.git \
    "`pwd`/repo/repo/libtiff"
git -C "`pwd`/repo/repo/libtiff" checkout c145a6c14978f73bb484c955eb9f84203efcb12e

cp "`pwd`/src/tiff_read_rgba_fuzzer.cc" \
    "`pwd`/repo/repo/libtiff/contrib/oss-fuzz/tiff_read_rgba_fuzzer.cc"

patch -p1 --no-backup-if-mismatch -d "`pwd`/repo/repo/libtiff" < "`pwd`/setup/libtiff.patch"

#find "`pwd`/vulnerability" -name "*.patch" | \
#while read patch; do
#    echo "Applying $patch"
#    name=${patch##*/}
#    name=${name%.patch}
#    #mkdir -p "`pwd`/repo/$name"
#
#    if [ -f "`pwd`/repo/$name/canary.patch" ]; then
#        patch -p1 -b -d "`pwd`/repo/repo/$(basename "$(pwd)")" < "`pwd`/repo/$name/canary.patch"
#    fi
#
#done

cd "`pwd`/repo/repo/"
"./build.sh"
