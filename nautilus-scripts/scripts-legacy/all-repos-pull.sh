#!/bin/bash

# Specify the root directory
ROOT_DIR="."

# Function to pull latest changes
pull_latest_changes() {
    local dir="$1"
    if [ -d "$dir/.git" ]; then
        echo "Pulling latest changes in: $dir"
        (cd "$dir" && git pull)
    fi
}

# Export the function for use with find
export -f pull_latest_changes

# Use find to search for directories and pull latest changes if they're Git repos
find "$ROOT_DIR" -type d -exec bash -c 'pull_latest_changes "$0"' {} \;

echo "Done!"
