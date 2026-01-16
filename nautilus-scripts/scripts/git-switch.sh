#!/bin/bash

# Git Switch Branch Script
# Usage: git-switch.sh <path> <branch> [--recursive]
#
# Arguments:
#   path        - Directory path to operate on
#   branch      - Target branch name
#   --recursive - If set, find and switch all repos inside path
#
# Behavior:
#   - Checks for uncommitted changes before switching
#   - Skips repos with dirty working directory
#   - After successful switch, performs git pull
#   - Shows color-coded summary at the end

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters
SUCCESS_COUNT=0
SKIPPED_COUNT=0
FAILED_COUNT=0
declare -a SKIPPED_REPOS
declare -a FAILED_REPOS

# Parse arguments
TARGET_PATH="$1"
TARGET_BRANCH="$2"
RECURSIVE=false

if [ "$3" == "--recursive" ]; then
    RECURSIVE=true
fi

# Validate arguments
if [ -z "$TARGET_PATH" ]; then
    echo -e "${RED}Error: No path provided${NC}"
    exit 1
fi

if [ -z "$TARGET_BRANCH" ]; then
    echo -e "${RED}Error: No branch provided${NC}"
    exit 1
fi

if [ ! -d "$TARGET_PATH" ]; then
    echo -e "${RED}Error: Path does not exist: $TARGET_PATH${NC}"
    exit 1
fi

# Function to check if repo has uncommitted changes
is_dirty() {
    local dir="$1"
    cd "$dir" || return 1
    [ -n "$(git status --porcelain 2>/dev/null)" ]
}

# Function to switch a single repo
switch_repo() {
    local dir="$1"

    if [ ! -d "$dir/.git" ]; then
        echo -e "${YELLOW}⚠ Not a git repository: $dir${NC}"
        return 1
    fi

    echo -e "${BLUE}→ Processing: $dir${NC}"
    cd "$dir" || return 1

    # Check for uncommitted changes
    if is_dirty "$dir"; then
        echo -e "${YELLOW}  ⚠ Skipped - uncommitted changes detected${NC}"
        git status --short | sed 's/^/    /'
        SKIPPED_REPOS+=("$dir (uncommitted changes)")
        ((SKIPPED_COUNT++))
        return 1
    fi

    # Fetch latest from remote
    echo -e "${CYAN}  Fetching...${NC}"
    git fetch --all --quiet 2>/dev/null

    # Check if branch exists (local or remote)
    if ! git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH" && \
       ! git show-ref --verify --quiet "refs/remotes/origin/$TARGET_BRANCH"; then
        echo -e "${RED}  ✗ Branch '$TARGET_BRANCH' not found${NC}"
        FAILED_REPOS+=("$dir (branch '$TARGET_BRANCH' not found)")
        ((FAILED_COUNT++))
        return 1
    fi

    # Switch to branch
    echo -e "${CYAN}  Switching to '$TARGET_BRANCH'...${NC}"
    output=$(git switch "$TARGET_BRANCH" 2>&1)
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}  ✗ Failed to switch${NC}"
        echo "$output" | sed 's/^/    /'
        FAILED_REPOS+=("$dir (switch failed)")
        ((FAILED_COUNT++))
        return 1
    fi

    # Pull latest changes
    echo -e "${CYAN}  Pulling...${NC}"
    output=$(git pull 2>&1)
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}  ✗ Failed to pull${NC}"
        echo "$output" | sed 's/^/    /'
        FAILED_REPOS+=("$dir (pull failed)")
        ((FAILED_COUNT++))
        return 1
    fi

    if echo "$output" | grep -q "Already up to date"; then
        echo -e "${GREEN}  ✓ Switched to '$TARGET_BRANCH' (already up to date)${NC}"
    else
        echo -e "${GREEN}  ✓ Switched to '$TARGET_BRANCH' and updated${NC}"
    fi

    ((SUCCESS_COUNT++))
    return 0
}

# Main execution
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
if [ "$RECURSIVE" = true ]; then
    echo -e "${BLUE}  Git Switch Branch - All Repositories${NC}"
else
    echo -e "${BLUE}  Git Switch Branch - Single Repository${NC}"
fi
echo -e "${BLUE}  Target branch: ${CYAN}$TARGET_BRANCH${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

if [ "$RECURSIVE" = true ]; then
    # Find all git repositories and switch
    while IFS= read -r -d '' gitdir; do
        repo_dir=$(dirname "$gitdir")
        switch_repo "$repo_dir"
        echo ""
    done < <(find "$TARGET_PATH" -name ".git" -type d -print0 2>/dev/null)
else
    # Switch single repo
    switch_repo "$TARGET_PATH"
fi

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

if [ $SUCCESS_COUNT -gt 0 ]; then
    echo -e "${GREEN}  ✓ $SUCCESS_COUNT repo(s) switched to '$TARGET_BRANCH'${NC}"
fi

if [ $SKIPPED_COUNT -gt 0 ]; then
    echo -e "${YELLOW}  ⚠ $SKIPPED_COUNT repo(s) skipped:${NC}"
    for repo in "${SKIPPED_REPOS[@]}"; do
        echo -e "${YELLOW}    - $repo${NC}"
    done
fi

if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "${RED}  ✗ $FAILED_COUNT repo(s) failed:${NC}"
    for repo in "${FAILED_REPOS[@]}"; do
        echo -e "${RED}    - $repo${NC}"
    done
fi

if [ $SUCCESS_COUNT -eq 0 ] && [ $SKIPPED_COUNT -eq 0 ] && [ $FAILED_COUNT -eq 0 ]; then
    echo -e "${YELLOW}  No git repositories found${NC}"
fi

echo ""
