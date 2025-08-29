#!/bin/bash

# If no argument is provided, throw an error
if [ -z "$1" ]; then
    echo "No remote specified."
    return 1
fi
remote_target="$1"
# Fetch all remote branches
git fetch --all

# Check that $remote_target is a valid remote
if ! git remote get-url "$remote_target" &>/dev/null; then
    echo "Invalid remote: $remote_target"
    return 1
fi

# Push all remote branches to the specified remote
git push "$1" refs/remotes/origin/*:refs/heads/*