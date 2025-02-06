#!/bin/bash

# Set the interval in seconds (e.g., every 10 minutes)
INTERVAL=600

# Get the hostname
HOSTNAME=$(hostname)

# Set paths based on hostname
if [ "$HOSTNAME" == "homelab-0" ]; then
    BASE_DIR="/home/xeseuses/thoughtvoyager"
elif [ "$HOSTNAME" == "fedora" ]; then
    BASE_DIR="/home/ruben/Documents/thoughtvoyager"
else
    echo "Unknown hostname: $HOSTNAME"
    exit 1
fi

while true; do
    echo "Running initial update script..."

    # Sync posts from Obsidian to Hugo
    echo "Syncing posts from Obsidian..."
    bash "$BASE_DIR/sync_posts.sh"

    # Clean up orphaned directories in public/posts
    echo "Cleaning up public/posts directory..."
    CONTENT_DIR="$BASE_DIR/content/posts"
    PUBLIC_DIR="$BASE_DIR/public/posts"

    for dir in "$PUBLIC_DIR"/*/; do
        dir_name=$(basename "$dir")
        if [ ! -f "$CONTENT_DIR/$dir_name.md" ]; then
            echo "Removing orphaned directory: $dir"
            rm -rf "$dir"
        fi
    done

	    # Process markdown files (optional step, if you want to keep it)
	    echo "Processing image links in markdown files..."
	    python3 "$BASE_DIR/convert_obsidian_links.py"

    # Generate the static files using Hugo
    echo "Running Hugo..."
    hugo --cleanDestinationDir

    # Check if Hugo executed successfully
    if [ $? -eq 0 ]; then
        echo "Hugo build completed successfully. Uploading to GitHub..."
        # Upload to GitHub (after Hugo build)
       bash  "$BASE_DIR/upload_to_github.sh"
    else
        echo "Hugo build failed. Update script will not run again."
    fi

    echo "Waiting $INTERVAL seconds before next run..."
    sleep $INTERVAL
done

