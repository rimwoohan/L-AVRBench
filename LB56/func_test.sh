#!/bin/bash
set -o pipefail    

pushd "$SRC/graphicsmagick-clean" > /dev/null || { echo "FAIL"; exit 1; }
if make -j"$(nproc)" check 2>&1 | tee run.log; then
    echo "PASS"
    exit 0
else
    grep -E "ERROR:|runtime error|AddressSanitizer" run.log || true
    echo "FAIL"
    exit 1
fi