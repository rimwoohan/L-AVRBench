#!/bin/bash
set -e

### ex) ./make.sh SND001

FUZZER="`pwd`/../../../../afl_asan/AFL"
TARGET_HOME="`pwd`/libsndfile"
patch_name=${2%.patch}
OUT="`pwd`/../$1/out/$patch_name"

mkdir -p $OUT

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export LDFLAGS="-L$FUZZER/../out -g -fsanitize=address"

export LIBS="-lrt -l:afl_driver.o -l:afl-llvm-rt.o -lstdc++"

cd "$TARGET_HOME"
#./autogen.sh
#./configure --disable-shared --enable-ossfuzzers
make -j$(nproc) clean
make -j$(nproc) ossfuzz/sndfile_fuzzer

cp -v ossfuzz/sndfile_fuzzer $OUT/
