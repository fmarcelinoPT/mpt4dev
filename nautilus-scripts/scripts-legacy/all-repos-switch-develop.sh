#!/bin/bash

# Specify the root directory
ROOT_DIR="."

# Function to switch to 'develop' branch
switch_to_develop() {
    local dir="$1"
    if [ -d "$dir/.git" ]; then
        echo "Switching to develop in: $dir"
        (cd "$dir" && git switch develop && git clean -fd && git reset --hard)
    fi
}

# Export the function for use with find
export -f switch_to_develop

# Use find to search for directories and switch to develop if they're Git repos
find "$ROOT_DIR" -type d -exec bash -c 'switch_to_develop "$0"' {} \;

echo "Done!"
