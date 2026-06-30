#!/bin/bash

cd oss-fuzz_new || exit 1

python3 infra/helper.py build_fuzzers --sanitizer address libxml2 ../libxml2
python3 infra/helper.py reproduce libxml2 api ../clusterfuzz-testcase-minimized-api-6179328546635776 \
    > sec_test_output.log 2>&1

# Check for the stack-buffer-overflow error
if grep "ERROR: AddressSanitizer: stack-buffer-overflow" sec_test_output.log; then
    echo "FAIL"
else
    echo "PASS"
fi