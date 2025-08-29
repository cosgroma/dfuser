#!/bin/bash

# Default values
GITHUB_USER="cosgroma"
GITHUB_VISIBILITY="private"
BASE_DIR="/mnt/e/repos/sergeant/core"
LOG_FILE="gh_repo_create.log"
DRY_RUN=false

# Logging functions
log_info() { echo "[INFO] $1" | tee -a "$LOG_FILE"; }
log_warn() { echo "[WARN] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[ERROR] $1" | tee -a "$LOG_FILE"; }

# Function to show help message
show_help() {
    echo "Usage: $0 [-u github_user] [-v visibility] [-d base_dir] [-c config_file] [-n]"
    echo "  -u github_user   GitHub username (default: your-github-username)"
    echo "  -v visibility    Repository visibility (default: private)"
    echo "  -d base_dir      Base directory to process (default: ./sergeant/core)"
    echo "  -c config_file   Configuration file"
    echo "  -r               Process directories recursively (default: true)"
    echo "  -n               Dry run mode"
    exit 0
}

# Parse command-line arguments
while getopts "u:v:d:c:rnh" opt; do
    case $opt in
        u) GITHUB_USER="$OPTARG" ;;
        v) GITHUB_VISIBILITY="$OPTARG" ;;
        d) BASE_DIR="$OPTARG" ;;
        c) source "$OPTARG" ;;
        r) RECURSIVE=true ;;
        n) DRY_RUN=true ;;
        h) show_help ;;
        *) show_help ;;
    esac
done

# Function to clone a bare repo and initialize a local git repo
clone_repo() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path" .git)
    
    log_info "Cloning $repo_name from bare repo $repo_path..."
    
    if [ "$DRY_RUN" = false ]; then
        git clone --bare "$repo_path" "$repo_name"
        cd "$repo_name" || exit
        git config --bool core.bare false
        git reset --hard HEAD
        cd ..
    else
        log_info "Dry run: git clone --bare $repo_path $repo_name"
    fi
}

# Function to create a new GitHub repo using gh cli
create_github_repo() {
    local repo_name="$1"

    if gh repo view "$GITHUB_USER/$repo_name" > /dev/null 2>&1; then
        log_info "GitHub repo $repo_name already exists."
    else
        log_info "Creating GitHub repo $repo_name..."
        if [ "$DRY_RUN" = false ]; then
            gh repo create "$GITHUB_USER/$repo_name" --"$GITHUB_VISIBILITY" --source="$repo_name" --remote="origin" --push
        else
            log_info "Dry run: gh repo create $GITHUB_USER/$repo_name --$GITHUB_VISIBILITY --source=$repo_name --remote=origin --push"
        fi
    fi
}

# Function to add submodules for subdirectories
add_submodules() {
    local parent_repo="$1"
    shift
    local submodules=("$@")

    log_info "Adding submodules to $parent_repo..."
    cd "$parent_repo" || exit
    
    for submodule in "${submodules[@]}"; do
        local submodule_name=$(basename "$submodule" .git)
        log_info "Adding submodule $submodule_name..."
        if [ "$DRY_RUN" = false ]; then
            git submodule add "git@github.com:$GITHUB_USER/$submodule_name.git" "$submodule_name"
            git commit -m "Added submodule $submodule_name"
        else
            log_info "Dry run: git submodule add git@github.com:$GITHUB_USER/$submodule_name.git $submodule_name"
        fi
    done
    
    if [ "$DRY_RUN" = false ]; then
        git push origin main
    else
        log_info "Dry run: git push origin main"
    fi
    cd ..
}

# Function to recursively process directories and submodules
process_directory() {
    local parent_path="$1"
    local subdirs=("${2}")

    # Step 1: Create the parent repo
    local parent_repo_name=$(basename "$parent_path")
    mkdir "$parent_repo_name"
    cd "$parent_repo_name" || exit
    git init
    git commit --allow-empty -m "Initial commit for $parent_repo_name"
    git branch -M main
    cd ..

    create_github_repo "$parent_repo_name"

    # Step 2: Process the subdirectories (submodules)
    if [ ${#subdirs[@]} -gt 0 ]; then
        for subdir in "${subdirs[@]}"; do
            # Check if the subdir is a bare repo or a directory that will hold submodules
            if [[ "$subdir" == *.git ]]; then
                clone_repo "$subdir"
                create_github_repo "$(basename "$subdir" .git)"
            else
                process_directory "$subdir" "$(find "$subdir" -maxdepth 1 -mindepth 1 -type d -or -name "*.git")"
            fi
        done

        add_submodules "$parent_repo_name" "${subdirs[@]}"
    fi
}

find_git_repos() {
    if [ ! -d "$1" ]; then
        log_error "Directory $1 does not exist."
        return 1
    fi
    git_repos=$(find "$1" -type d -name "*.git" | grep -v "build/_deps/sandbox")
    # /home/cosgroma/wksp/sergeant/designs/t1tl/core/apps/sdr/.git
    # /home/cosgroma/wksp/sergeant/designs/t1tl/comp/th/src/tools/python-ssm/.git
    # /home/cosgroma/wksp/sergeant/designs/t1tl/comp/cc/sandbox/cpp-starter-project-cmake/.git
    # /home/cosgroma/wksp/sergeant/designs/t1tl/comp/cc/sandbox/embedded-cli/.git
    # /home/cosgroma/wksp/sergeant/designs/t1tl/comp/cc/build/_deps/os-src/.git
    # /home/cosgroma/wksp/sergeant/designs/t1tl/comp/cc/build/_deps/gnss-src/.git
    # /home/cosgroma/wksp/sergeant/designs/t1tl/.git
    # return list of parent directories of the found .git dirs
    echo "$git_repos" | xargs -n1 dirname | sort -u
}

# Main function to process the entire structure
main() {
    log_info "Starting recursive processing from base directory: $BASE_DIR"
    
    # Get all subdirectories and bare repos under the base_dir
    local subdirs
    if [ ! -d "$BASE_DIR" ]; then
        log_error "Base directory $BASE_DIR does not exist."
        exit 1
    fi

    # if recursive is true (find all subdirs and .git repos)
    if [ "$RECURSIVE" = true ]; then
        mapfile -t subdirs < <(find "$BASE_DIR" -type d -or -name "*.git")
    else
        # only find immediate subdirs and .git repos
        mapfile -t subdirs < <(find "$BASE_DIR" -maxdepth 1 -mindepth 1 -type d -or -name "*.git")
    fi
    if [ ${#subdirs[@]} -eq 0 ]; then
        log_warn "No subdirectories or bare repos found in $BASE_DIR."
        exit 0
    fi

    # Print the found subdirectories and repos
    log_info "Found the following subdirectories and repos:"
    for subdir in "${subdirs[@]}"; do
        log_info " - $subdir"
    done

    # process_directory "$BASE_DIR" ${subdirs[@]}
}

# Run the recursive process
main
