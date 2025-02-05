#!/bin/bash

# Set the interval in seconds (e.g., every 10 minutes)
INTERVAL=600

while true; do
    echo "Running initial update script..."
    
    /home/ruben/Documents/thoughtvoyager/updateblog.sh

    # Clean up orphaned directories in public/posts
    echo "Cleaning up public/posts directory..."
    CONTENT_DIR="/home/xeseuses/thoughtvoyager/content/post"
    PUBLIC_DIR="/home/xeseuses/thoughtvoyager/public/posts"

    for dir in "$PUBLIC_DIR"/*/; do
        dir_name=$(basename "$dir")
        if [ ! -f "$CONTENT_DIR/$dir_name.md" ]; then
            echo "Removing orphaned directory: $dir"
            rm -rf "$dir"
        fi
    done

    python3 /home/ruben/Documents/thoughtvoyager/convert_obsidian_links.py
    # Generate the static files using Hugo
    echo "Running Hugo..."
    hugo --cleanDestinationDir

    # Check if Hugo executed successfully
    if [ $? -eq 0 ]; then
        echo "Hugo build completed successfully. Running update script again..."
	/home/ruben/Documents/thoughtvoyager/updateblog.sh
    else
        echo "Hugo build failed. Update script will not run again."
    fi

    echo "Waiting $INTERVAL seconds before next run..."
    sleep $INTERVAL
done

