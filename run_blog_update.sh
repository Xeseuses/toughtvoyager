#!/bin/bash

# Set the interval in seconds (e.g., every 10 minutes)
INTERVAL=600

while true; do
    echo "Running initial update script..."

    # Sync posts from Obsidian to Hugo
    echo "Syncing posts from Obsidian..."
    /home/ruben/Documents/thoughtvoyager/sync_posts.sh

    # Clean up orphaned directories in public/posts
    echo "Cleaning up public/posts directory..."
    CONTENT_DIR="/home/ruben/Documents/thoughtvoyager/content/posts"
    PUBLIC_DIR="/home/ruben/Documents/thoughtvoyager/public/posts"

    for dir in "$PUBLIC_DIR"/*/; do
        dir_name=$(basename "$dir")
        if [ ! -f "$CONTENT_DIR/$dir_name.md" ]; then
            echo "Removing orphaned directory: $dir"
            rm -rf "$dir"
        fi
    done

    # Process markdown files (optional step, if you want to keep it)
    echo "Processing image links in markdown files..."
    python3 /home/ruben/Documents/thoughtvoyager/convert_obsidian_links.py

    # Generate the static files using Hugo
    echo "Running Hugo..."
    hugo --cleanDestinationDir

    # Check if Hugo executed successfully
    if [ $? -eq 0 ]; then
        echo "Hugo build completed successfully. Uploading to GitHub..."
        # Upload to GitHub (after Hugo build)
        /home/ruben/Documents/thoughtvoyager/upload_to_github.sh
    else
        echo "Hugo build failed. Update script will not run again."
    fi

    echo "Waiting $INTERVAL seconds before next run..."
    sleep $INTERVAL
done

