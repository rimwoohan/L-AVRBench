#!/bin/bash
set -e

### ex) ./security_test.sh 001.patch

patch_name=${1%.patch}

mkdir -p "test_result/security"

if [ -f "`pwd`/out/$patch_name/tiffcp" ]; then
    "`pwd`/out/$patch_name/tiffcp" -M "`pwd`/poc" tmp.out > "`pwd`/test_result/security/$patch_name" 2>&1
else
    exit 11
fi

