#!/bin/bash
# set -e

cd binutils-gdb
make distclean
find . -name 'config.cache' -exec rm -f {} +
./configure --disable-werror
make clean
make -j`nproc` 
if [ $? -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi

