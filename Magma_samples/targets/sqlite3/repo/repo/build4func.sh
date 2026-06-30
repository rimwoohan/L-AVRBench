#!/bin/bash
set -e

FUZZER="`pwd`/../../../../afl_asan/AFL"
TARGET="`pwd`/../.."
WORK="`pwd`/work"
OUT="`pwd`/out"

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export LDFLAGS="-L$FUZZER/../out -g -fsanitize=address"

export LIBS="-lrt -l:afl_driver.o -l:afl-llvm-rt.o -lstdc++"

cd "`pwd`/sqlite3"
rm -rf "$WORK"
mkdir -p "$WORK"
rm -rf "$OUT"
mkdir -p "$OUT"
cd "$WORK"

export CFLAGS="$CFLAGS -DSQLITE_DEBUG=1"

$OUT/../sqlite3/configure --disable-shared --enable-rtree
make clean
make -j$(nproc)
make sqlite3.c

#$CC $CFLAGS -I. \
#    "$OUT/../sqlite3/test/ossfuzz.c" "./sqlite3.o" \
#    -o "$OUT/sqlite3_fuzz" \
#    $LDFLAGS $LIBS -pthread -ldl -lm

