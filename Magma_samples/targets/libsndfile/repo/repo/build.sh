#!/bin/bash
set -e

FUZZER="`pwd`/../../../../afl_asan/AFL"
TARGET="`pwd`/../.."
OUT="`pwd`/out"

mkdir -p $OUT

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export LDFLAGS="-L$FUZZER/../out -g -fsanitize=address"

export LIBS="-lrt -l:afl_driver.o -l:afl-llvm-rt.o -lstdc++"

cd "$OUT/../libsndfile"
./autogen.sh
./configure --disable-shared --enable-ossfuzzers
make -j$(nproc) clean
make -j$(nproc) ossfuzz/sndfile_fuzzer

cp -v ossfuzz/sndfile_fuzzer $OUT/
