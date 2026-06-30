#!/bin/bash

# Function to find and execute remove.sh up to a specified depth
find_and_execute() {
  local current_depth=$1
  local max_depth=2
  local log_file_name="log_ftest.txt"
  local log_sfile_name="log_stest.txt"
  local log_whole_name="log_all_test.txt"
  local can_fail_name="canary_fail.txt"
  local can_folder_name="canary_failed"

  if [ "$current_depth" -gt "$max_depth" ]; then
    return
  fi

  for dir in */; do
    if [ -d "$dir" ]; then
      cd "$dir" || continue
      if [ -f "./remove_test_result_all.sh" ]; then
        echo "Executing ./remove_test_result_all.sh in $(pwd)"
        chmod +x ./remove_test_result_all.sh # Ensure the script is executable
        ./remove_test_result_all.sh

      else
        echo "./remove_test_result_all.sh not found in $(pwd)"
      fi

      if [ -f "./remove_all.sh" ]; then
        echo "Executing ./remove_all.sh in $(pwd)"
        chmod +x ./remove_all.sh # Ensure the script is executable
        ./remove_all.sh

      else
        echo "./remove_all.sh not found in $(pwd)"
      fi

      if [ -f "$log_file_name" ] || [ -f "$log_sfile_name" ] || [ -f "$log_whole_name" ]; then
        echo "Removing $log_whole_name , $log_file_name and $log_sfile_name in $(pwd)"
        rm -f "$log_file_name"
        rm -f "$log_sfile_name"
        rm -f "$log_whole_name"
      fi

      if [ -f "$can_fail_name" ]; then
        echo "Removing $can_fail_name in $(pwd)"
        rm -f "$can_fail_name"
        rm -rf "$can_folder_name"
      fi

      find_and_execute $((current_depth + 1)) # Recurse into subdirectories
      cd ..
    fi
  done
}

# Start the process from the current directory at depth 1
find_and_execute 1

