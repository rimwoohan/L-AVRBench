#!/bin/bash

make clean || true
make distclean || true

CPPFLAGS="-I/usr/include/libxml2" \
LDFLAGS="-L/usr/lib" \
./configure --prefix="$WORK" --without-perl --with-quantum-depth=16 --with-xml=yes --without-jbig

make -j"$(nproc)"
if [ $? -ne 0 ]; then
    echo "FAIL"
    exit 1
fi

make install
if [ $? -ne 0 ]; then
    echo "FAIL"
    exit 1
fi

echo "PASS"
exit 0
