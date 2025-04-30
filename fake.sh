#!/bin/bash

set -euo pipefail

REMOTE=${REMOTE:-origin}

if [ -z "${1:-}" ]; then
  echo "Usage: ./create-fake-pr.sh <branch-name>"
  exit 1
fi

BRANCH_NAME="$1"
FILE_NAME="change_$(date +%s%N | tail -c 6).txt"
RANDOM_CONTENT="This is a fake change created at $(date)"
TMP_FILE="$FILE_NAME"

# Ensure we're on main and up-to-date
echo "🔄 Checking out main..."
git checkout main &>/dev/null
git pull "$REMOTE" main

echo ""

# Create and switch to new branch
echo "🌿 Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

echo ""

# Create random file
echo "$RANDOM_CONTENT" > "$TMP_FILE"
git add "$TMP_FILE"
git commit -m "chore: add $TMP_FILE"

echo ""

# Push to remote and set upstream
echo "🚀 Pushing to $REMOTE/$BRANCH_NAME..."
git push --set-upstream "$REMOTE" "$BRANCH_NAME"

echo ""

# Switch back to main
git checkout main &>/dev/null
echo "✅ Done! Created branch '$BRANCH_NAME' and pushed '$TMP_FILE'"

