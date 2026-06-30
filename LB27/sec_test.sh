#!/bin/bash

cd oss-fuzz_new || exit 1

python3 infra/helper.py build_fuzzers --sanitizer memory libxml2 ../libxml2
python3 infra/helper.py reproduce libxml2 schema ../clusterfuzz-testcase-minimized-schema-6168810711482368 \
    > sec_test_output.log 2>&1

# Check for the stack-buffer-overflow error
if grep "MemorySanitizer" sec_test_output.log; then
    echo "FAIL"
else
    echo "PASS"
fi
