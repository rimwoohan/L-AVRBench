#!/bin/bash
set -e

### ex) ./security_test.sh 001.patch

patch_name=${1%.patch}

mkdir -p "test_result/security"

if [ -f "`pwd`/out/$patch_name/libxml2_xml_read_memory_fuzzer" ]; then
    "`pwd`/out/$patch_name/libxml2_xml_read_memory_fuzzer" "`pwd`/poc" > "`pwd`/test_result/security/$patch_name" 2>&1
else
    exit 11
fi

