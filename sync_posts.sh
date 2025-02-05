#!/bin/bash
set -euo pipefail

# Change to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Set variables for Obsidian to Hugo copy
sourcePath="/home/ruben/Documents/Extended Brain/Posts"
destinationPath="/home/ruben/Documents/thoughtvoyager/content/posts"

# Step 1: Check if source and destination directories exist
if [ ! -d "$sourcePath" ]; then
    echo "Source path does not exist: $sourcePath"
    exit 1
fi

if [ ! -d "$destinationPath" ]; then
    echo "Destination path does not exist: $destinationPath"
    exit 1
fi

# Step 2: Sync posts from Obsidian to Hugo content folder using rsync
echo "Syncing posts from Obsidian..."
rsync -av --delete "$sourcePath" "$destinationPath"
echo "Posts have been successfully synced."

