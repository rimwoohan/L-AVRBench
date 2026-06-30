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

cd "`pwd`/openssl"

CONFIGURE_FLAGS=""
if [[ $CFLAGS = *sanitize=memory* ]]; then
  CONFIGURE_FLAGS="no-asm"
fi

# the config script supports env var LDLIBS instead of LIBS
export LDLIBS="$LIBS"

#./config --debug enable-fuzz-libfuzzer enable-fuzz-afl enable-tests -DPEDANTIC \
#    -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION no-shared no-module enable-fips\
#    enable-tls1_3 enable-ssl-trace enable-rc5 enable-md2 \
#    enable-ec_nistp_64_gcc_128 enable-ssl3 enable-acvp-tests enable-dynamic-engine\
#    enable-ssl3-method enable-nextprotoneg enable-weak-ssl-ciphers \
#    $CFLAGS -fno-sanitize=alignment $CONFIGURE_FLAGS

make -j$(nproc) clean
make -j$(nproc) LDCMD="$CXX $CXXFLAGS"

#fuzzers=$(find fuzz -executable -type f '!' -name \*.py '!' -name \*-test '!' -name \*.pl)
#for f in $fuzzers; do
#    fuzzer=$(basename $f)
#    cp $f "$OUT/"
#done

