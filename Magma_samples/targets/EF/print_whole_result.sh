#!/bin/bash

### ex) ./print_combined_test_result.sh PNG001

directory_base="`pwd`/repo/$1/test_result"
functionality_dir="$directory_base/functionality"
security_dir="$directory_base/security"

functionality_pass_count=0
functionality_total_count=0
functionality_security_pass_count=0
security_pass_count=0
security_total_count=0

if [ -d "$functionality_dir" ] || [ -d "$security_dir" ]; then
    echo -e "\n--- Combined Tests ---"

    # Gather all unique file names from both directories
    all_files=$(ls "$functionality_dir" "$security_dir" 2>/dev/null | sort -u)

    # Calculate padding for alignment
    max_file_length=0
    for file in $all_files; do
        if [ ${#file} -gt $max_file_length ]; then
            max_file_length=${#file}
        fi
    done

    for file in $all_files; do
        functionality_file="$functionality_dir/$file"
        security_file="$security_dir/$file"

        functionality_result="Functionality | Not Tested"
        security_result="Security | Not Tested"

        functionality_passed=false
        security_passed=false

        # Functionality Test
        if [ -f "$functionality_file" ]; then
            functionality_total_count=$((functionality_total_count + 1))
            if grep -q "FAIL" "$functionality_file"; then
                functionality_result="Functionality | Fail"
            else
                functionality_result="Functionality | Pass"
                functionality_pass_count=$((functionality_pass_count + 1))
                functionality_passed=true
            fi
        fi

        # Security Test
        if [ -f "$security_file" ]; then
            security_total_count=$((security_total_count + 1))
            if grep -q "runtime error:" "$security_file" || grep -q "AddressSanitize" "$security_file"; then
                security_result="Security | Fail"
            else
                security_result="Security | Pass"
                security_pass_count=$((security_pass_count + 1))
                security_passed=true
            fi
        fi

        # Count files that pass both tests
        if [ "$functionality_passed" = true ] && [ "$security_passed" = true ]; then
            functionality_security_pass_count=$((functionality_security_pass_count + 1))
        fi

        # Print combined result for the file only if at least one test is conducted
        if [ "$functionality_result" != "Functionality | Not Tested" ] || [ "$security_result" != "Security | Not Tested" ]; then
            printf "%-${max_file_length}s : \t%-15s \t%s\n" "$file" "$functionality_result" "$security_result"
        fi
    done

    # Functionality Summary
    if [ "$functionality_total_count" -gt 0 ]; then
        echo -e "\nTotal Passed Functionality Tests: $functionality_pass_count/$functionality_total_count"
    else
        echo -e "\nNo Functionality Tests Found."
    fi

    # Security Summary
    if [ "$security_total_count" -gt 0 ]; then
        echo "Total Passed Security Tests: $security_pass_count/$security_total_count"
    else
        echo "No Security Tests Found."
    fi

    # Combined Functionality and Security Pass Summary
    echo "Total Passed Both Functionality and Security Tests: $functionality_security_pass_count/$security_total_count"
else
    echo -e "\nBoth functionality and security test directories do not exist."
fi
