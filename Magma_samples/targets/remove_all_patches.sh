#!/bin/bash

# Remove all *.patch files in the patches folder up to depth=1

# Function to find and execute remove.sh up to a specified depth
find_and_execute() {
  local current_depth=$1
  local max_depth=1
  local log_file_name="log_ftest.txt"
  local log_sfile_name="log_stest.txt"

  if [ "$current_depth" -gt "$max_depth" ]; then
    return
  fi

  for dir in */; do
    if [ -d "$dir" ]; then
      cd "$dir" || continue
      
      local base_dir="$(pwd)/patches"
      echo "Processing directory: $(pwd)  $base_dir"
      find "$base_dir" -mindepth 1 -maxdepth 2 -type f -name "*.patch" -exec rm -f {} +
      find "$base_dir" -mindepth 1 -maxdepth 2 -type f -name "*.patch.reject" -exec rm -f {} +
      find_and_execute $((current_depth + 1)) # Recurse into subdirectories

      local base_dir="$(pwd)/../../preprocessing/model_patches"
      echo "Processing directory: $(pwd)  $base_dir"
      find "$base_dir" -mindepth 1 -maxdepth 2 -type f -name "*.patch" -exec rm -f {} +
      find_and_execute $((current_depth + 1)) # Recurse into subdirectories
      cd .. || exit
    fi
  done
}

# Start the process from the current directory at depth 1
find_and_execute 1
echo "All .patch files in the patches folder have been removed."
