#!/bin/bash

# Git Pull Script
# Usage: git-pull.sh <path> [--recursive]
#
# Arguments:
#   path        - Directory path to operate on
#   --recursive - If set, find and pull all repos inside path

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
SUCCESS_COUNT=0
FAILED_COUNT=0
declare -a FAILED_REPOS

# Parse arguments
TARGET_PATH="$1"
RECURSIVE=false

if [ "$2" == "--recursive" ]; then
    RECURSIVE=true
fi

# Validate path
if [ -z "$TARGET_PATH" ]; then
    echo -e "${RED}Error: No path provided${NC}"
    exit 1
fi

if [ ! -d "$TARGET_PATH" ]; then
    echo -e "${RED}Error: Path does not exist: $TARGET_PATH${NC}"
    exit 1
fi

# Function to pull a single repo
pull_repo() {
    local dir="$1"

    if [ ! -d "$dir/.git" ]; then
        echo -e "${YELLOW}⚠ Not a git repository: $dir${NC}"
        return 1
    fi

    echo -e "${BLUE}→ Pulling: $dir${NC}"

    cd "$dir" || return 1
    output=$(git pull 2>&1)
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        if echo "$output" | grep -q "Already up to date"; then
            echo -e "${GREEN}  ✓ Already up to date${NC}"
        else
            echo -e "${GREEN}  ✓ Updated successfully${NC}"
            echo "$output" | sed 's/^/    /'
        fi
        ((SUCCESS_COUNT++))
        return 0
    else
        echo -e "${RED}  ✗ Failed to pull${NC}"
        echo "$output" | sed 's/^/    /'
        FAILED_REPOS+=("$dir")
        ((FAILED_COUNT++))
        return 1
    fi
}

# Main execution
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
if [ "$RECURSIVE" = true ]; then
    echo -e "${BLUE}  Git Pull - All Repositories${NC}"
else
    echo -e "${BLUE}  Git Pull - Single Repository${NC}"
fi
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

if [ "$RECURSIVE" = true ]; then
    # Find all git repositories and pull
    while IFS= read -r -d '' gitdir; do
        repo_dir=$(dirname "$gitdir")
        pull_repo "$repo_dir"
        echo ""
    done < <(find "$TARGET_PATH" -name ".git" -type d -print0 2>/dev/null)
else
    # Pull single repo
    pull_repo "$TARGET_PATH"
fi

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}  ✓ $SUCCESS_COUNT repo(s) pulled successfully${NC}"

if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "${RED}  ✗ $FAILED_COUNT repo(s) failed:${NC}"
    for repo in "${FAILED_REPOS[@]}"; do
        echo -e "${RED}    - $repo${NC}"
    done
fi

echo ""
