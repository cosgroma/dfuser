#!/bin/bash

# If no argument is provided, throw an error
if [ -z "$1" ]; then
    echo "No remote specified."
    return 1
fi
remote_target="$1"
force="${2:-false}"
# Fetch all remote branches
git fetch origin

# Check that $remote_target is a valid remote
if ! git remote get-url "$remote_target" &>/dev/null; then
    echo "Invalid remote: $remote_target"
    return 1
fi

# Push all remote branches to the specified remote
git push "$1" refs/remotes/origin/*:refs/heads/*

# check if repo has submodules
if [ -f .gitmodules ]; then
    # Initialize and update submodules
    # git submodule update --init --recursive
    git submodule foreach 'git fetch origin'

    # Loop through each submodule
    if [ "$force" = true ]; then
        git submodule foreach "git push -f $remote_target refs/remotes/origin/*:refs/heads/* || true"
    else
        git submodule foreach "git push $remote_target refs/remotes/origin/*:refs/heads/* || true"
    fi
fi