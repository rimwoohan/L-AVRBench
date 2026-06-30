#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && \
    sudo apt-get install -y make autoconf automake libtool curl tcl zlib1g-dev tcl-dev

curl "https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=8c432642572c8c4b" \
  -o "`pwd`/sqlite.tar.gz" && \
mkdir -p "`pwd`/repo/repo/sqlite3" && \
tar -C "`pwd`/repo/repo/sqlite3" --strip-components=1 -xzf "`pwd`/sqlite.tar.gz"
rm "`pwd`/sqlite.tar.gz"

patch -p1 --no-backup-if-mismatch -d "`pwd`/repo/repo/sqlite3" < "`pwd`/setup/tclexec-ignore-stderr.patch"
cd "`pwd`/repo/repo/"
"./build.sh"
