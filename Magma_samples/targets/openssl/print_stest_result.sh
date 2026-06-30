#!/bin/bash

### ex) ./print_test_result.sh PNG001

directory="`pwd`/repo/$1/test_result/security"
pass_count=0
total_count=0

for file in "$directory"/*; do
    total_count=$((total_count + 1))
    
    if grep -q "CANARY_DETECT" "$file"; then
        echo "$(basename "$file") Security Test Fail"
    
    elif grep -q "AddressSanitize" "$file"; then
        echo "$(basename "$file") Security Test Fail"
    
    else
        echo "$(basename "$file") Security Test Pass"
        pass_count=$((pass_count + 1))
    fi
done

echo "Total Passed Security Tests: $pass_count/$total_count"
