#!/bin/bash

# This script will check for git updates for the git repository it is in.
# It will alert the user if there are changes in the repository or if the remote repository is ahead of the local repository.

DFUSER_GIT_REPO="$HOME/.dfuser"

function print_associative_array() {
    declare -n arr=$1
    for key in "${!arr[@]}"; do
        echo "$key: ${arr[$key]}"
    done
}

function has_uncommited_changes() {
    if [ -n "$(git status --porcelain)" ]; then
        return 0
    else
        return 1
    fi
}
function check_for_updates() {
    # Check for DFUSER_GIT_REPO
    if [ -d $DFUSER_GIT_REPO ]; then
        # Check for updates
        {
            cd $DFUSER_GIT_REPO
            git fetch
            LOCAL=$(git rev-parse HEAD)
            REMOTE=$(git rev-parse @{u})
            BASE=$(git merge-base HEAD @{u})
            
            # echo "Local: $LOCAL"
            # echo "Remote: $REMOTE"
            # echo "Base: $BASE"
            if [ $LOCAL = $REMOTE ]; then
                echo "DFUSER is up-to-date"
                elif [ $LOCAL = $BASE ]; then
                echo "DFUSER needs to be updated"
                if has_uncommited_changes; then
                    echo "DFUSER has uncommited changes"
                    echo "Please commit your changes before updating"
                fi
                
                git pull
                
                elif [ $REMOTE = $BASE ]; then
                echo "DFUSER is ahead of the remote repository"
                git push
            else
                echo "DFUSER has diverged, what the F did you do?"
            fi
            
            # look for uncommited changes
            if [ -n "$(git status --porcelain)" ]; then
                echo "DFUSER has uncommited changes"
                # # an associative array to store the status of the files, the key will be the status and the value will be an array of files
                # declare -A files
                # for file in $(git status --porcelain); do
                #     status=${file:0:2}
                #     echo "Status: $status"
                #     files[$status]+="$file "
                #     echo "File: $file"
                # done
                # print_associative_array files
                # cnt=0
                # for file in $(git status --porcelain); do
                #     cnt=$((cnt+1))
                #     if [ $((cnt%2)) -eq 1 ]; then
                #         echo -n "Status: $file"
                #     fi
                #     if [ $((cnt%2)) -eq 0 ]; then
                #         echo ": $file"
                #     fi
                # done
            fi
            
            # look for untracked files
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                echo "DFUSER has untracked files"
                # for file in $(git ls-files --others --exclude-standard); do
                #     echo "Untracked file: $file"
                # done
            fi
            
        }
    else
        echo "DFUSER is not installed"
    fi
}

# check_for_updates


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
    # check if ~/.dfuser/scripts/dfbin exists
    if [ -d "$HOME/.dfuser/scripts/dfbin" ]; then
        # check if ~/.dfbin exists
        if [ -d "$HOME/.dfbin" ]; then
            # find all files in ~/.dfuser/scripts/dfbin
            for file in $(find $HOME/.dfuser/scripts/dfbin -type f); do
                # check if the file exists in ~/.dfbin
                if [ -f "$HOME/.dfbin/$(basename $file)" ]; then
                    # determine which file is newer
                    if [ $file -nt "$HOME/.dfbin/$(basename $file)" ]; then
                        echo "File: $file is newer than ~/.dfbin/$(basename $file)"
                    else
                        echo "File: $file is older than ~/.dfbin/$(basename $file)"
                        # copy the ~/.dfbin/$file to ~/.dfuser/scripts/dfbin/$file
                        echo "Copying $file to ~/.dfbin/$(basename $file)"
                        cp "$HOME/.dfbin/$(basename $file)" $file
                    fi
                    # compare the contents of the files
                    # diff $file "$HOME/.dfbin/$(basename $file)"
                else
                    echo "File: $file does not exist in ~/.dfbin"
                fi
            done
        else
            echo "Directory: $HOME/.dfbin does not exist"
        fi
    else
        echo "Directory: $HOME/.dfuser/scripts/dfbin does not exist"
    fi
}

diff_dfbin

