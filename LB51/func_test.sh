#!/bin/bash
# set -e

cd binutils-gdb

make -C binutils check
if [ $? -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi

