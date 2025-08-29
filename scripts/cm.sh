#!/bin/bash

# Function to check if there are uncommitted changes
has_uncommitted_changes() {
    # Check if there are any uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        return 0
    fi
    
    # Check if there are any untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        return 0
    fi
    
    return 1
}
# Function to update a repository
update_repository() {
    local repo_dir="$1"
    local log_file="$2"
    echo "Updating, creating local branches, and pushing to remotes in repository: $repo_dir"
    
    (
        cd "$repo_dir" || { echo "Unable to access directory: $repo_dir"; return; }
        
        # Log output to the specified log file
        echo "Updating repository: $repo_dir" >> "$log_file"
        git fetch --all >> "$log_file" 2>&1
        
        if ! has_uncommitted_changes; then
            # Create and update local branches and push to remotes
            git for-each-ref --format='%(refname:short)' refs/remotes/origin | while read -r remote_branch; do
                local_branch="${remote_branch#origin/}"
                
                # Create and checkout local branch if it doesn't exist
                if ! git show-ref --quiet "refs/heads/$local_branch"; then
                    git checkout -b "$local_branch" "$remote_branch" >> "$log_file" 2>&1
                fi
                
                # Update and push local branch to remote
                git checkout "$local_branch" >> "$log_file" 2>&1
                git pull origin "$local_branch" >> "$log_file" 2>&1
                git push origin "$local_branch" >> "$log_file" 2>&1
            done
        else
            echo "Skipped branch operations due to uncommitted changes." >> "$log_file"
        fi
    )
}

# Specify the log file path as an absolute path based on the current working directory
LOG_FILE="$PWD/update_repos_log.txt"

# Clear log file
> "$LOG_FILE"

# Loop through all subdirectories in the current directory
for dir in */; do
    if [ -d "$dir/.git" ]; then
        update_repository "$dir" "$LOG_FILE"
    fi
done