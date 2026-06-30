#!/bin/bash

## USAGE : ./do_all.sh VA
#           (execute for vul_advisor)
## USAGE : ./do_all.sh VM
#           (execute for vul_master)

# Function to find and execute scripts up to a specified depth
find_and_test_execute() {
  local current_depth=$1
  local max_depth=2
  local security_file_name="do_whole_stest.sh"
  local function_file_name="do_whole_ftest.sh"


  if [ "$current_depth" -gt "$max_depth" ]; then
    return
  fi

  for dir in */; do
    if [ -d "$dir" ]; then
      cd "$dir" || continue
      if [ -f "$security_file_name" ]; then
        echo "Executing $security_file_name in $(pwd)"
        chmod +x "$security_file_name" # Ensure the script is executable
        ./"$security_file_name"
        if [ $(basename "$(pwd)") = "openssl" ]; then
            export ASAN_OPTIONS=detect_leaks=1
            ./"$function_file_name"
            export ASAN_OPTIONS=detect_leaks=0
        else
            ./"$function_file_name"
        fi
        # ./print_stest_result.sh
        # ./print_ftest_result.sh
        # ./log_whole_ftest.sh
        # ./log_whole_stest.sh
        ./log_whole_once.sh
      else
        echo "$security_file_name not found in $(pwd)"
      fi
      
      find_and_test_execute $((current_depth + 1)) # Recurse into subdirectories
      cd ..
    fi
  done
}

if [ "$1" = "VA" ]; then
    export VUL_ADV=1
else
    export VUL_ADV=0
fi

export ASAN_OPTIONS=detect_leaks=0
export C_INCLUDE_PATH=/usr/include/tcl8.6/
# Start the process from the current directory at depth 1
find_and_test_execute 1
