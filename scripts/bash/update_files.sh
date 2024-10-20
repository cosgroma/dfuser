#!/bin/bash

# Directory containing the .docx files from input arguments
input_dir="$1"

# Check if the directory exists
if [ ! -d "$input_dir" ]; then
    echo "Directory not found: $input_dir"
    exit 1
fi

# Loop through each .docx file in the directory
for file in "$input_dir"/*.docx; do
    if [ -f "$file" ]; then
        # Get the file's base name without extension
        base_name=$(basename "$file" .docx)

        # Remove spaces and other illegal characters including '[' and ']'
        new_name=$(echo "$base_name" | tr -s ' ' | tr ' ' '_' | tr -cd '[[:alnum:]]._-' | tr '[:upper:]' '[:lower:]' | tr -s '\[\]' '_')

        # remove leading _
        new_name=$(echo "$new_name" | sed 's/^_//')

        # replace '-' with '_'
        new_name=$(echo "$new_name" | sed 's/-/_/g')

        # Check if the new name is different from the old name
        if [ "$base_name" != "$new_name" ]; then
            new_path="$input_dir/$new_name.docx"

            # Check if the new name already exists
            if [ -e "$new_path" ]; then
                echo "Warning: $new_path already exists. Skipping renaming."
            else
                mv "$file" "$new_path"
                echo "Renamed $file to $new_name.docx"
            fi
        fi
    fi
done

echo "Renaming complete."