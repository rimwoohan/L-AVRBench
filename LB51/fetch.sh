#!/bin/bash
set -e

mkdir -p dev-patch

git clone https://sourceware.org/git/binutils-gdb.git 
cd binutils-gdb
git checkout c98a4545dc7bf2bcaf1de539c4eb84784680eaa4^
git format-patch -1 c98a4545dc7bf2bcaf1de539c4eb84784680eaa4
cp *.patch ../dev-patch/fix.patch

