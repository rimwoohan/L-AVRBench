#!/bin/bash
set -e

sudo apt-get update && \
    sudo apt-get install -y git make autoconf autogen automake build-essential libasound2-dev \
  libflac-dev libogg-dev libtool libvorbis-dev libopus-dev libmp3lame-dev \
  libmpg123-dev pkg-config python

mkdir -p "`pwd`/repo/repo/libsndfile"

git clone --no-checkout https://github.com/libsndfile/libsndfile.git \
    "`pwd`/repo/repo/libsndfile"
git -C "`pwd`/repo/repo/libsndfile" checkout 86c9f9eb7022d186ad4d0689487e7d4f04ce2b29

patch -p1 --no-backup-if-mismatch -d "`pwd`/repo/repo/libsndfile" < "`pwd`/setup/libsndfile.patch"

cd "`pwd`/repo/repo"
"./build.sh"
