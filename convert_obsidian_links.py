import os
import re

print("Script started...")

# Function to replace Obsidian-style links with Hugo-style links
def convert_obsidian_links(file_path, base_url):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
        
        print("Original Content:\n", content)  # See if it reads correctly

    # Regular expression to find Obsidian-style links (e.g., [[Title]])
    pattern = r'\[\[\s*(.*?)\s*\]\]'
    
    # Function to replace each found link with the Hugo-style link
    def replace_link(match):
        title = match.group(1).strip()
        # Create the Hugo URL (adjust this part based on your folder structure if needed)
        hugo_url = f"{base_url}/{title.replace(' ', '-').lower()}/"
        print(f"Replacing: [[{title}]] -> [{title}]({hugo_url})")  # Debugging line
        return f"[{title}]({hugo_url})"

    # Replace all Obsidian-style links with Hugo-style links
    updated_content = re.sub(pattern, replace_link, content)
    
    print("Updated Content:\n", updated_content)  # Check if anything changes
    # Write the updated content back to the file
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(updated_content)

# Function to process all Markdown files in a directory
def process_directory(directory, base_url):
    print(f"Processing directory: {directory}")  # Debugging line
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                print(f"Found Markdown file: {file_path}")  # Debugging line
                convert_obsidian_links(file_path, base_url)


# Set the directory containing your .md files and the base URL for your Hugo site
directory = '/home/xeseuses/thoughtvoyager/content/posts'
base_url = 'https://thoughtvoyager.com/posts/posts'
# Process all files in the specified directory
process_directory(directory, base_url)

