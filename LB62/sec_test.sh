#!/bin/bash
export ASAN_OPTIONS=detect_leaks=0

mkdir -p sec_test

cd ImageMagick
make distclean
CC=gcc CFLAGS="-fsanitize=address -g -O0" ./configure
make clean
make -j$(nproc)

./utilities/magick convert ../assertion-failed-in-LockSemaphoreInfo-semaphore295 output.png \
  > ../sec_test/out.log 2>&1

if grep "Assertion" ../sec_test/out.log | grep -q "failed"; then
    echo "FAIL"
else
    echo "PASS"
fi