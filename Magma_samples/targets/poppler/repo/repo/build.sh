#!/bin/bash
set -e

FUZZER="`pwd`/../../../../afl_asan/AFL"
TARGET="`pwd`/../.."
WORK="`pwd`/work"
OUT="$WORK/../out"

rm -rf "$WORK"
mkdir -p "$WORK"
mkdir -p "$WORK/lib" "$WORK/include"

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export LDFLAGS="-L$FUZZER/../out -g -fsanitize=address"

export LIBS="-lrt -l:afl_driver.o -l:afl-llvm-rt.o -lstdc++"

pushd "`pwd`/freetype2"
./autogen.sh
./configure --prefix="$WORK" --with-harfbuzz=no --disable-shared PKG_CONFIG_PATH="$WORK/lib/pkgconfig"
make -j$(nproc) clean
make -j$(nproc)
make install
popd

mkdir -p "$WORK/poppler"
cd "$WORK/poppler"
rm -rf *

EXTRA=""
AR=/usr/bin/ar
RANLIB=/usr/bin/ranlib

test -n "$AR" && EXTRA="$EXTRA -DCMAKE_AR=$AR"
test -n "$RANLIB" && EXTRA="$EXTRA -DCMAKE_RANLIB=$RANLIB"

cmake "$WORK/../poppler" \
  $EXTRA \
  -DCMAKE_BUILD_TYPE=debug \
  -DBUILD_SHARED_LIBS=OFF \
  -DFONT_CONFIGURATION=generic \
  -DBUILD_GTK_TESTS=OFF \
  -DBUILD_QT5_TESTS=OFF \
  -DBUILD_CPP_TESTS=OFF \
  -DENABLE_LIBPNG=ON \
  -DENABLE_LIBTIFF=ON \
  -DENABLE_LIBJPEG=ON \
  -DENABLE_SPLASH=ON \
  -DENABLE_UTILS=ON \
  -DWITH_Cairo=ON \
  -DENABLE_CMS=none \
  -DENABLE_LIBCURL=OFF \
  -DENABLE_GLIB=OFF \
  -DENABLE_GOBJECT_INTROSPECTION=OFF \
  -DENABLE_QT5=OFF \
  -DENABLE_LIBCURL=OFF \
  -DWITH_NSS3=OFF \
  -DFREETYPE_INCLUDE_DIRS="$WORK/include/freetype2" \
  -DFREETYPE_LIBRARY="$WORK/lib/libfreetype.a" \
  -DICONV_LIBRARIES="/usr/lib/x86_64-linux-gnu/libc.so" \
  -DCMAKE_EXE_LINKER_FLAGS_INIT="$LIBS"
make -j$(nproc) poppler poppler-cpp pdfimages pdftoppm
EXTRA=""

mkdir -p $OUT
cp "$WORK/poppler/utils/"{pdfimages,pdftoppm} "$OUT/"

$CXX $CXXFLAGS -std=c++11 -I"$WORK/poppler/cpp" -I"$WORK/../poppler/cpp" \
    "$TARGET/src/pdf_fuzzer.cc" -o "$OUT/pdf_fuzzer" \
    "$WORK/poppler/cpp/libpoppler-cpp.a" "$WORK/poppler/libpoppler.a" \
    "$WORK/lib/libfreetype.a" $LDFLAGS $LIBS -ljpeg -lz \
    -lopenjp2 -lpng -ltiff -llcms2 -lm -lpthread -pthread

