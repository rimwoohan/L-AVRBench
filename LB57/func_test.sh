#!/bin/bash
set -o pipefail    

for i in $(seq 1 28); do
  $WORK/bin/gm convert -size 100x100 xc:blue "Tile${i}_out.miff"
done

pushd "$SRC/graphicsmagick" > /dev/null || { echo "FAIL"; exit 1; }
if make check 2>&1 | tee run.log; then
    echo "PASS"
    exit 0
else
    grep -E "ERROR:|runtime error|AddressSanitizer" run.log || true
    echo "FAIL"
    exit 1
fi