import os
import re

# Function to convert Obsidian links to Hugo links
def convert_to_hugo_link(text):
    # Regular expression to match Obsidian-style links [[filename]]
    obsidian_link_pattern = r'\[\[(.*?)\]\]'
    
    # Function to replace each link with Hugo-style link
    def replace_link(match):
        filename = match.group(1)
        # Hugo URL format for posts (correcting the `post/` to `posts/`)
        return f'[{filename}](/posts/{filename.lower().replace(" ", "-")}/)'

    # Replace all Obsidian links with Hugo-style links
    return re.sub(obsidian_link_pattern, replace_link, text)

# Function to process each markdown file in the given directory
def process_files(vault_dir):
    for root, _, files in os.walk(vault_dir):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Convert links in the content
                updated_content = convert_to_hugo_link(content)

                # If content has changed, write it back to the file
                if content != updated_content:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(updated_content)
                    print(f"Updated: {file_path}")

# Hugo posts directory
hugo_posts_directory = '/home/xeseuses/thoughtvoyager/content/posts'

# Run the script
process_files(hugo_posts_directory)

