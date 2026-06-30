#!/bin/bash

### ex) ./print_ftest_result.sh PNG001

directory="`pwd`/repo/$1/test_result/functionality"
pass_count=0
total_count=0

for file in "$directory"/*; do
    total_count=$((total_count + 1))
    
    if grep -q "FAIL" "$file"; then
        echo "$(basename "$file") Functionality Test Fail"
    
    else
        echo "$(basename "$file") Functionality Test Pass"
        pass_count=$((pass_count + 1))
    fi
done

echo "Total Passed Functionality Tests: $pass_count/$total_count"
