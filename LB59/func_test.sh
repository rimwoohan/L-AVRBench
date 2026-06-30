#!/bin/bash
set -o pipefail    

OLD_CFLAGS="$CFLAGS"
OLD_CXXFLAGS="$CXXFLAGS"
OLD_LDFLAGS="$LDFLAGS"
OLD_SANITIZER="$SANITIZER"

pushd "$SRC/graphicsmagick" > /dev/null || { echo "FAIL"; exit 1; }

unset CFLAGS CXXFLAGS LDFLAGS SANITIZER
if make -j"$(nproc)" check 2>&1 | tee run.log; then
    echo
    echo "PASS"
    RESULT=0
else
    grep -E "ERROR:|runtime error|AddressSanitizer" run.log || true
    echo
    echo "FAIL"
    RESULT=1
fi

export CFLAGS="$OLD_CFLAGS"
export CXXFLAGS="$OLD_CXXFLAGS"
export LDFLAGS="$OLD_LDFLAGS"
export SANITIZER="$OLD_SANITIZER"
exit "$RESULT"