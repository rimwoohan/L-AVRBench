#!/bin/bash
#set -e

FUZZER="`pwd`/../../../../afl_asan/AFL"

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export LDFLAGS="-L$FUZZER/../out -g -fsanitize=address"

export LIBS="-lrt -l:afl_driver.o -l:afl-llvm-rt.o -lstdc++"

WORK="`pwd`/work"
rm -rf "$WORK"
mkdir -p "$WORK"
mkdir -p "$WORK/lib" "$WORK/include"

cd "`pwd`/libtiff"
./autogen.sh
set -e
./configure --disable-shared --prefix="$WORK"
make -j$(nproc) clean
make -j$(nproc)
make install

OUT="$WORK/../out"
mkdir -p $OUT
cp "$WORK/bin/tiffcp" "$OUT"
cp "$WORK/bin/tiff2ps" "$OUT"

$CXX $CXXFLAGS -std=c++11 -I$WORK/include \
    contrib/oss-fuzz/tiff_read_rgba_fuzzer.cc -o $OUT/tiff_read_rgba_fuzzer \
    $WORK/lib/libtiffxx.a $WORK/lib/libtiff.a -lz -ljpeg -ljbig -Wl,-Bstatic -llzma -Wl,-Bdynamic \
    $LDFLAGS $LIBS
