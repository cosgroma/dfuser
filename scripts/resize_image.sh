#!/bin/bash

resize_image() {
    # Set default values for arguments
    local url="$1"
    # parse the filename from the url
    local filename=$(cut -d'/' -f1- <<<"$url" | rev | cut -d'/' -f1 | rev)
    # remove the extension from the filename
    filename=${filename%.*}
    local output_dir="${2:-$(pwd)}"
    local bg_color="${3:-rgb(255,255,255)}"
    local temp_dir="/tmp"
    local temp_file="$temp_dir/temp_image.png"
    local target_width=1500
    local target_height=600
    local output_file="$output_dir/$filename-${target_width}x${target_height}.png"
    # initialize the target width and height, have it based on a 20% reduction of the target keeping the aspect ratio
    local reduction_percentage=50
    local init_target_width=$((target_width - (target_width * reduction_percentage / 100)))
    local init_target_height=$((target_height - (target_height * reduction_percentage / 100)))

    # Download the image
    wget -O "$temp_file" "$url"

    # Resize and convert the image
    convert "$temp_file" -resize "${init_target_width}x${init_target_height}^" -gravity center -background "$bg_color" -extent "${target_width}x${target_height}" "$output_file"

    # Clean up the temporary file
    rm "$temp_file"

    echo "Image has been resized and saved to $output_file"
}