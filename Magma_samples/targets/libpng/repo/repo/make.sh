#!/bin/bash
set -e

### ex) ./make.sh PNG001 001.patch

AFL_HOME="`pwd`/../../../../afl_asan/AFL"

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"

export LDFLAGS="-L$AFL_HOME/../out -g -fsanitize=address"
export LIBS="-lrt -l:afl_driver.o -l:afl-llvm-rt.o -lstdc++"

#build the libpng library
TARGET_HOME="`pwd`/libpng"
patch_name=${2%.patch}
OUT="`pwd`/../$1/out/$patch_name"
mkdir -p "$OUT"
cd $TARGET_HOME

#autoreconf -f -i
#./configure --disable-shared
make -j$(nproc) clean
make -j$(nproc) libpng16.la

cp .libs/libpng16.a "$OUT"

# build libpng_read_fuzzer.
$CXX $CXXFLAGS -std=c++11 -I. \
     contrib/oss-fuzz/libpng_read_fuzzer.cc \
     -o $OUT/libpng_read_fuzzer \
     $LDFLAGS .libs/libpng16.a $LIBS -lz
