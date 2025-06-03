#!/bin/bash

# Bash Script for Linux/WSL

# Set paths
SOURCE_PATH="/home/xeseuses/thoughtvoyager/input/Posts"
DEST_PATH="/home/xeseuses/thoughtvoyager/thoughtvoyager/content/posts"
REPO_URL="git@github.com:Xeseuses/toughtvoyager.git"

# Exit immediately on error
set -euo pipefail

# Navigate to repo root
cd "$DEST_PATH/../.."

# Check required commands
for cmd in git hugo python3; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed. Aborting."
        exit 1
    fi
done

# Step 1: Initialize git if needed
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git remote add origin "$REPO_URL"
fi

# Ensure origin remote exists
if ! git remote | grep -q origin; then
    git remote add origin "$REPO_URL"
fi

# Step 2: Sync posts from Obsidian
echo "Syncing posts from Obsidian to Hugo..."
rsync -av --delete "$SOURCE_PATH/" "$DEST_PATH/"

# Step 3: Process Markdown files
if [ ! -f "images.py" ]; then
    echo "images.py not found. Skipping image processing."
else
    echo "Processing images with Python..."
    python3 images.py
fi

# Step 4: Build Hugo site
echo "Building Hugo site..."
./hugo --cleanDestinationDir --minify

# Step 5: Stage and commit changes
if [ -n "$(git status --porcelain)" ]; then
    echo "Staging and committing changes..."
    git add .
    git commit -m "New Blog Post on $(date '+%Y-%m-%d %H:%M:%S')"
else
    echo "No changes to commit."
fi

# Step 6: Push to master
echo "Pushing to master..."
git push origin master

# Step 7: Push public folder to hostinger branch
BRANCH_EXISTS=$(git branch --list hostinger-deploy)
if [ -n "$BRANCH_EXISTS" ]; then
    git branch -D hostinger-deploy
fi

git subtree split --prefix public -b hostinger-deploy
git push origin hostinger-deploy:hostinger --force
git branch -D hostinger-deploy

echo "✅ All done! Site synced, built, and deployed."

