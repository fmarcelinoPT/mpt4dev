#!/bin/bash

# Specify the root directory
ROOT_DIR="."

# Function to switch to 'main' branch
switch_to_main() {
    local dir="$1"
    if [ -d "$dir/.git" ]; then
        echo "Switching to main in: $dir"
        (cd "$dir" && git switch main && git clean -fd && git reset --hard)
    fi
}

# Export the function for use with find
export -f switch_to_main

# Use find to search for directories and switch to main if they're Git repos
find "$ROOT_DIR" -type d -exec bash -c 'switch_to_main "$0"' {} \;

echo "Done!"
