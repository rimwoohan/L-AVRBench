#!/bin/bash
set -e

cd libxml2

./autogen.sh
automake --add-missing # just in case

CFLAGS="-g -O0"

CONFIG_OPTIONS="--enable-static --disable-shared --without-threads --without-lzma --without-python"
#CONFIG_OPTIONS="--disable-shared"

./configure CC="clang" CXX="clang++" CFLAGS="${CFLAGS}" ${CONFIG_OPTIONS}

make clean
if make -j$(nproc); then
    echo "PASS"
else
    echo "FAIL"
fi

