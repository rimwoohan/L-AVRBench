#!/bin/bash

# Function to traverse directories up to depth=2 and execute fetch.sh
fetch_in_directories() {
  local current_depth=$1
  local max_depth=2

  # Stop recursion if the depth exceeds the max depth
  if [ "$current_depth" -gt "$max_depth" ]; then
    return
  fi

  # Loop through directories in the current directory
  for dir in */; do
    if [ -d "$dir" ]; then
      cd "$dir" || continue
      # Check if fetch.sh exists and execute it
      if [ -f "./fetch.sh" ]; then
        echo "Executing fetch.sh in $(pwd)"
        chmod +x ./fetch.sh # Ensure fetch.sh is executable
        ./fetch.sh
      else
        echo "fetch.sh not found in $(pwd)"
      fi

      if [ -f "./apply_vulnerability.sh" ]; then
        echo "Executing apply_vulnerability.sh in $(pwd)"
        chmod +x ./apply_vulnerability.sh # Ensure fetch.sh is executable
        ./apply_vulnerability.sh
      else
        echo "apply_vulnerability.sh not found in $(pwd)"
      fi
      # Recurse into subdirectories
      fetch_in_directories $((current_depth + 1))
      cd ..
    fi
  done
}

# Start traversing from depth=1
export C_INCLUDE_PATH=/usr/include/tcl8.6/
../preprocessing/ready.sh
fetch_in_directories 2
