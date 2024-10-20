#!/bin/bash

# This script will check for git updates for the git repository it is in.
# It will alert the user if there are changes in the repository or if the remote repository is ahead of the local repository.


# find bash and python scripts in the following directories ($HOME, $HOME/workspace, $HOME/workspace/sergeant, $HOME/workspace/sergeant/scripts)

# Directory search array
# directories=(
#     "$HOME"
#     "$HOME/workspace"
#     "$HOME/workspace/sergeant"
#     "$HOME/workspace/sergeant/scripts"
#     "$HOME/workspace/utils/dotfiles/dfbin"
# )

# echo "Directories: ${directories[@]}"

# for dir in "${directories[@]}"; do
#     echo "Directory: $dir"
#     if [ -d $dir ]; then
#         # find all bash scripts
#         for file in $(find $dir -maxdepth 1 -type f -name "*.sh"); do
#             echo "Bash script: $file"
#         done
#         # find all python scripts
#         for file in $(find $dir -maxdepth 1 -type f -name "*.py"); do
#             echo "Python script: $file"
#         done
#     fi
# done

# compare the files and contents of the files in ~/.dfuser/scripts/dfbin with ~/.dfbin
function diff_dfbin() {
    # check the number of arguments
    if [ $# -ne 2 ]; then
        echo "Usage: diff_dfbin <target_dir> <remote_dir>"
        return
    fi
    local target_dir=$1
    local remote_dir=$2
    if [ ! -d "$target_dir" ]; then
        echo "Directory: $target_dir does not exist"
        return
    fi
    if [ ! -d "$remote_dir" ]; then
        echo "Directory: $remote_dir does not exist"
        return
    fi
    
    
    # find all files in the target directory
    for file in $(find $target_dir -type f -maxdepth 1); do
        # check if the file exists in the remote directory
        if [ -f "$remote_dir/$(basename $file)" ]; then
            remote_file="$remote_dir/$(basename $file)"
            # determine which file is newer
            if [ ! $file -nt "$remote_file" ]; then
                echo "File: $file is older than $remote_file"
                # diff $file "$remote_file"
                # echo "Copying $file to $remote_file"
                # cp "$remote_file" $file
            fi
            # compare the contents of the files
            # diff $file "$remote_dir/$(basename $file)"
        else
            echo "File: $file does not exist in $remote_dir"
        fi
    done

    # find all files in the remote directory
    for file in $(find $remote_dir -type f -maxdepth 1); do
        # check if the file exists in the target directory
        if [ ! -f "$target_dir/$(basename $file)" ]; then
            echo "File: $file does not exist in $target_dir"
            # move the file to the target directory
            echo "Moving $file to $target_dir"
            mv $file $target_dir
        fi
    done


}

DFUSER_DIR="$HOME/.dfuser"

target_dir="$DFUSER_DIR/scripts/dfbin"
# remote_dir="$HOME/.dfbin"
remote_dir="$DFUSER_DIR/sdk/scripts"

diff_dfbin $target_dir $remote_dir

# case statement for commands
# case $1 in
#     "update")
#         check_for_updates
#         ;;
#     "diff_dfbin")
#         diff_dfbin $2 $3
#         ;;
#     *)
#         echo "Usage: updater.sh <command>"
#         echo "Commands:"
#         echo "update: Check for updates for the git repository"
#         echo "diff_dfbin: Compare the files and contents of the files in the target directory with the remote directory"
#         ;;
# esac


