#!/bin/bash
set -e

sudo apt-get update && \
    sudo apt-get install -y git make autoconf automake libtool pkg-config zlib1g-dev \
        liblzma-dev

mkdir -p "`pwd`/repo/repo/libxml2"

git clone --no-checkout https://gitlab.gnome.org/GNOME/libxml2.git \
    "`pwd`/repo/repo/libxml2"
git -C "`pwd`/repo/repo/libxml2" checkout ec6e3efb06d7b15cf5a2328fabd3845acea4c815

patch -p1 --no-backup-if-mismatch -d "`pwd`/repo/repo/libxml2" < "`pwd`/setup/libxml2.patch"
cd "`pwd`/repo/repo/"
"./build.sh"
