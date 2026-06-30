#!/bin/bash
set -e

sudo apt-get update && \
    sudo apt-get install -y git make autoconf automake libtool zlib1g-dev

mkdir -p "`pwd`/repo/repo/libpng"

git clone --no-checkout https://github.com/glennrp/libpng.git "`pwd`/repo/repo/libpng"
git -C "`pwd`/repo/repo/libpng" checkout a37d4836519517bdce6cb9d956092321eca3e73b

patch -p1 --no-backup-if-mismatch -d "`pwd`/repo/repo/libpng" < "`pwd`/setup/libpng16.patch"
cd "`pwd`/repo/repo/"
"./build.sh"
