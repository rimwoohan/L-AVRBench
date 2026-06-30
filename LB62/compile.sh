#!/bin/bash
export ASAN_OPTIONS=detect_leaks=0

cd ImageMagick
make distclean
./configure --with-freetype=yes --with-fontconfig=yes

make clean

if make -j$(nproc); then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi