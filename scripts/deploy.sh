#!/bin/bash

# This deploy script will be run the the design directory
# The design directory has a comp directory
# The comp directory has named directories for each component

function get_component_names() {
    # Get component names using find with directory type
    component_names=$(find comp/ -maxdepth 1 -type d)
    # remove the first line
    component_names=$(echo "$component_names" | sed '1d')
    # get the basename of each component
    component_names=$(basename -a $component_names)
    # Remove trailing slash
    component_names=${component_names%/}
    # Remove leading comp/
    component_names=${component_names#comp/}
    echo $component_names
}

get_component_names

# Check if component directory has image-build-out directory
function check_component_image_build_out() {
    # Get component name
    component_name=$1
    # Check if component directory has image-build-out directory
    if ![ -d "comp/$component_name/image-build-out" ]; then
        echo "comp/$component_name/image-build-out does not exist"
    fi
}

function get_latest_component_git_tag() {
    # Get component name
    component_name=$1
    # create a subshell for changing directories
    (
        # Change directory to component directory
        cd comp/$component_name
        # Get latest git tag
        latest_git_tag=$(git describe --tags $(git rev-list --tags --max-count=1))
        echo $latest_git_tag
    )
}

get_latest_component_git_tag "sc"

# comp/<comp_name>/image-build-out/Makfile

function get_component_build_target() {
    # Get component name
    component_name=$1
    # Check if component directory has image-build-out directory
    if ! [ -d "comp/$component_name/image-build-out" ]; then
        echo "comp/$component_name/image-build-out does not exist"
        return;
    fi
    # Get component image build out makefile
    build_target=$(grep "# Build rule for target." -A 1 comp/$component_name/image-build-out/Makefile | tail -n 1)
    echo "$build_target"
}

get_component_build_target "sc"