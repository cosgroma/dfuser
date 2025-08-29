#!/bin/bash
# This script is used to create a new repositories on the git server


# Git Server Repo directory
GITDIR=/srv/git
GIT_SRV_IP=192.168.2.19



repolist=(cc
os
sc
em
sm
pp
mio
navpayload.pb.xqzu9eg-ffrb1156-1m-m.t1tl
sample_stream
pcu
semaxi
gencor
one_pps
ad9257
decimator
frequency_mixer
band_separator
collector
spectrum
cfc400x_fsbl
cfc400x_pmufw
magnom.pnt.xczu15eg-ffvc900-1l-i.nrl
th
smake
fm
)


function create_repo {
    echo "Creating repository $1"
    
    # check argument count
    if [ $# -ne 1 ]; then
        echo "Usage: create_repo <repo_name>"
        return 1
    fi
    
    # check if the repository already exists
    if [ -d $GITDIR/$1.git ]; then
        echo "Repository $1 already exists"
        return 1
    fi

    # Create the repository
    git init --bare $GITDIR/$1.git
}

function create_repo_with_namespaces {
    echo "Creating repository $1 in namespace $2"
    # check argument count
    if [ $# -ne 2 ]; then
        echo "Usage: create_repo_with_namespaces <repo_name> <namespace>"
        return 1
    fi
    # Create the namespace directory
    mkdir -p $GITDIR/$2
    git init --bare $GITDIR/$2/$1.git
}

function create_repos {
    for repo in ${repolist[@]}; do
        echo "Creating repository $repo"
        create_repo $repo
    done
}

# hint: Using 'master' as the name for the initial branch. This default branch name
# hint: is subject to change. To configure the initial branch name to use in all
# hint: of your new repositories, which will suppress this warning, call:
# hint:
# hint:   git config --global init.defaultBranch <name>
# hint:
# hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
# hint: 'development'. The just-created branch can be renamed via this command:
# hint:
# hint:   git branch -m <name>

# Function to change the default branch name
function change_default_branch {
    echo "Changing default branch name to $1"
    git config --global init.defaultBranch $1
}

function change_default_branch_for_repos {
    for repo in ${repolist[@]}; do
        echo "Changing default branch name for repository $repo"
        cd $GITDIR/$repo.git
        git symbolic-ref HEAD refs/heads/main
    done
}


# git submodule foreach cname=`env | grep name | cut -d'=' -f2`
# function to add a git remote to the submodule
function add_remote_to_submodule {
    echo "Adding remote $1 to submodule $2"
    # check argument count
    if [ $# -ne 2 ]; then
        echo "Usage: add_remote_to_submodule <remote_name> <submodule_name>"
        return 1
    fi
    remote_name=$1
    submodule_name=$2
    # Add the remote to the submodule
    git remote add $1 git@$GIT_SRV_IP:$GITDIR/$2.git
}


function update_submodules_with_github_remote {
    # check if the GITURL environment variable is set
    if [ $# -eq 1 ]; then
        GITURL_TARGET=$1
    else
        
        if [ -z "$GITURL" ]; then
            echo "GITURL environment variable is not set"
            echo "Please set the GITURL environment variable to the URL of your github repository or pass it as an argument"
            echo "Usage: update_submodules_with_github_remote [github_url]"
            return 1
        fi
    fi
    echo "Updating submodules with github remote"
    # Get all sumodules paths
    submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    
    for submodule in $submodules; do
        submodule_name=$(basename $submodule)
        # url="$GITURL_TARGET/$submodule_name"
        # echo "Adding remote $url to submodule $submodule_name"
        pushd . > /dev/null
        cd $submodule
        origin_url=$(git remote get-url origin)
        # echo "Origin URL for $submodule_name is $origin_url"
        base_url=$(basename $origin_url)
        url="$GITURL_TARGET/$base_url"
        echo "Adding remote $url to submodule $submodule_name"
        git remote add github $url
        popd > /dev/null
    done
}


function do_from_submodules {
    echo "Doing $1 from submodules"
    # Get all sumodules paths
    submodules=$(git config --file .gitmodules --get-regexp url | awk '{ print $2 }')
    
    for submodule in $submodules; do
        repo=$(basename $submodule)
        # remove .git if it exists
        repo=${repo%.git}
        create_github_repo_using_gh_cli $repo
        
    done
}

function create_github_repo_using_gh_cli {
    # check if the repository already exists
    if gh repo view $1 &> /dev/null; then
        echo "Repository $1 already exists"
        return 1
    fi
    echo "Creating github repository $1"
    gh repo create $1 --private
    sleep 1
}

function create_github_repos_using_gh_cli {
    for repo in ${repolist[@]}; do
        echo "Creating github repository $repo"
        create_github_repo_using_gh_cli $repo
        sleep 1
    done
}

function make_submodule_branches {
    echo "Updating submodules"
    # Get all sumodules paths
    submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    remote_name="origin"
    # check if the user has provided a remote name
    if [ $# -eq 1 ]; then
        remote_name=$1
    elif [ $# -gt 1 ]; then
        echo "Usage: make_submodule_branches [remote_name]"
        echo "Too many arguments"
        return 1
    fi
    for submodule in $submodules; do
        submodule_name=$(basename $submodule)
        pushd .
        cd $submodule
        # get all remote branches from origin and create a local branch for each
        for branch in $(git branch -r | grep -v HEAD); do
            # branch_no_remote=$(echo $branch | sed 's/origin\///')
            # check if we already have a local branch for this remote branch
            if git show-ref --verify --quiet refs/heads/${branch#origin/}; then
                echo "Branch ${branch#origin/} already exists"
                continue
            fi
            git branch --track $branch
        done
        
        popd
    done
}

# Function to delete all submodule branches
# This will delete all local branches that are not present on the remote
# and also delete the remote branches on the gitserver
function delete_submodule_branches {
    # check argument count
    if [ $# -eq 0 ]; then
        echo "skipping delete on remote"
        # use gitserver as default remote
        gitserver="gitserver"
    elif [ $# -eq 1 ]; then
        # use the first argument as the remote name
        remote_name=$1
    else
        echo "Usage: delete_submodule_branches [remote_name]"
        echo "Too many arguments"
        return 1
    fi
    remote_name=$1

    # check if the user really wants to delete the branches
    read -p "Are you sure you want to delete all submodule branches? This cannot be undone. (y/n) " -n 1 -r
    echo    # move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting"
        return 1
    fi
    # check if the user is in the root of the repository
    if [ ! -f .gitmodules ]; then
        echo "You must run this script from the root of the repository"
        return 1
    fi
    # check if the user has write access to the remote_name
    if ! git remote -v | grep -q remote_name; then
        echo "You must add a remote named 'remote_name' to the repository"
        return 1
    fi
    echo "Deleting submodule branches"
    # Get all sumodules paths
    submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    
    for submodule in $submodules; do
        submodule_name=$(basename $submodule)
        pushd .
        cd $submodule
        # get all remote branches from 'remote_name' and delete the local branch for each
        for branch in $(git branch | grep -v HEAD | grep $remote_name); do
            echo "Deleting branch $branch"
            git branch -D $branch
            # delete the remote branch
            git push $remote_name --delete $branch
            
        done
        
        popd
    done
}

# function create_repo
# function create_repo_with_namespaces
# function create_repos
# function change_default_branch
# function change_default_branch_for_repos
# function add_remote_to_submodule
# function update_submodules_with_github_remote
# function do_from_submodules
# function create_github_repo_using_gh_cli
# function create_github_repos_using_gh_cli
# function make_submodule_branches
# function delete_submodule_branches