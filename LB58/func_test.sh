#!/bin/bash
set -o pipefail    

OLD_CFLAGS="$CFLAGS"
OLD_CXXFLAGS="$CXXFLAGS"
OLD_LDFLAGS="$LDFLAGS"
OLD_SANITIZER="$SANITIZER"

export LSAN_OPTIONS=detect_leaks=0
pushd "$SRC/graphicsmagick" > /dev/null || { echo "FAIL"; exit 1; }
for i in $(seq 1 28); do
  $WORK/bin/gm convert -size 100x100 xc:blue "Tile${i}_out.miff"
done

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
unset LSAN_OPTIONS

export CFLAGS="$OLD_CFLAGS"
export CXXFLAGS="$OLD_CXXFLAGS"
export LDFLAGS="$OLD_LDFLAGS"
export SANITIZER="$OLD_SANITIZER"
exit "$RESULT"