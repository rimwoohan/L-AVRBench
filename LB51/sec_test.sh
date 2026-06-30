#!/bin/bash
# set -e
cd binutils-gdb

# CFLAGS="-DFORTIFY_SOURCE=2 -fno-omit-frame-pointer -g -Wno-error -O0"
# CXXFLAGS="-DFORTIFY_SOURCE=2 -fno-omit-frame-pointer -g -Wno-error -O0"
CFLAGS="-DFORTIFY_SOURCE=2 -fsanitize=address -fno-omit-frame-pointer -g -Wno-error -O0"
CXXFLAGS="-DFORTIFY_SOURCE=2 -fsanitize=address -fno-omit-frame-pointer -g -Wno-error -O0"
LDFLAGS="-fsanitize=address"

CONFIG_OPTIONS="--disable-shared --disable-gdb --disable-libdecnumber --disable-readline --disable-sim"

make distclean
find . -name 'config.cache' -exec rm -f {} +
CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" ./configure ${CONFIG_OPTIONS}

make CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" -j`nproc`
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi

./binutils/readelf  -a ../poc.bin > ../out.log 2>&1
if grep -q "SUMMARY: AddressSanitizer: double-free" ../out.log; then
    echo "FAIL"
    exit 1
else
    echo "PASS"
    exit 0
fi

