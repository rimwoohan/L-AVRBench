#!/bin/bash
set -e

FUZZER="`pwd`/../../../../afl_asan/AFL"
TARGET="`pwd`/../../"
OUT="`pwd`/out"

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export LDFLAGS="-L$FUZZER/../out -g -fsanitize=address"

export LIBS="-lrt -l:afl_driver.o -l:afl-llvm-rt.o -lstdc++"

cd "`pwd`/libxml2"
./autogen.sh \
    --with-http=no \
    --with-python=no \
    --with-lzma=yes \
    --with-threads=no \
    --disable-shared
make -j$(nproc) clean
make -j$(nproc) all

mkdir -p $OUT
cp xmllint "$OUT"

for fuzzer in libxml2_xml_read_memory_fuzzer libxml2_xml_reader_for_file_fuzzer; do
  $CXX $CXXFLAGS -std=c++11 -Iinclude/ -I"$TARGET/src/" \
      "$TARGET/src/$fuzzer.cc" -o "$OUT/$fuzzer" \
      .libs/libxml2.a $LDFLAGS $LIBS -lz -llzma
done

