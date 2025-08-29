# Manages the .dfuser script files
# This script will be sourced by .bashrc
# .bashrc will also source all the files in $HOME/.dfuser if they don't start with a dot or an underscore and end with .sh
# This script will manage how these files will be activated on new shells by managing the names of these files
# This can also do a few other things like:
# * What environment variables are available in the current shell
# It will have an interactive mode for managing the user level scripts which cover activating nvm, conda, etc

DFBIN_DIR=$HOME/.dfbin
DFUSER_DIR=$HOME/.dfuser
DFUSER_SCRIPTS_DIR=$HOME/.dfuser/scripts
DFUSER_TEMPLATE_DIR=$HOME/.dfuser/templates

# Test if the dfuser template directory exists
if ! [[ -d $DFUSER_TEMPLATE_DIR ]]; then
    echo "Creating the dfuser template directory"
    mkdir $DFUSER_TEMPLATE_DIR
fi

# Test if the dfuser directory exists
if ! [[ -d $DFUSER_DIR ]]; then
    echo "Creating the dfuser directory"
    mkdir $DFUSER_DIR
fi

# Test if the dfbin directory exists
if ! [[ -d $DFBIN_DIR ]]; then
    echo "Creating the dfbin directory"
    mkdir $DFBIN_DIR
fi

declare -A dfuser_files
declare -A dfuser_files_enabled

function get_dfuser_files() {
    files=$(find $DFUSER_SCRIPTS_DIR -maxdepth 1 -name "*.sh" | sort | uniq)
    for f in $files; do
        fn=$(basename $f)
        # if dfuser_files does not contain the key, add it
        if [[ ! -v dfuser_files[$fn] ]]; then
            dfuser_files[$fn]=$f
        fi
        # parse the file to get the environment variables
        # env_vars=$(get_file_env_set $f)
        
    done
}

function get_dfuser_script_modules() {
    dirs=$(find $DFUSER_SCRIPTS_DIR -mindepth 1 -maxdepth 1 -type d)
    for d in $dirs; do
        echo $d
    done
}

function get_max_str_len() {
    local max_len=0
    for key in "${!dfuser_files[@]}"; do
        if [[ ${#key} -gt $max_len ]]; then
            max_len=${#key}
        fi
    done
    echo -n $max_len
}

function show_dfuser_files() {
    get_dfuser_files
    max_len=$(get_max_str_len)
    for key in "${!dfuser_files[@]}"; do
        if [[ -v dfuser_files_enabled[$key] ]]; then
            enabled_str="|✅|"
        else
            enabled_str="|--|"
        fi
        file_path=$(echo -n ${dfuser_files[$key]})
        # remove DFUSER_DIR from the file path
        file_path=$(echo -n ${file_path#$DFUSER_DIR})
        printf "%${max_len}s %s➡️  %s\n" $key $enabled_str $file_path
    done
}

function setup_symbolic_links() {
    get_dfuser_files
    for key in "${!dfuser_files[@]}"; do
        echo "Setting up symbolic link for $key"
        ln -s "$DFUSER_DIR/${dfuser_files[$key]}" "$DFUSER_SCRIPTS_DIR/$key"
    done
}

function enable_dfuser_file() {
    local key=$1
    # Check if key ${dfuser_files[$key]} exists
    if [[ -e ${dfuser_files[$key]} ]]; then
        echo "⚡ Enabling $key"
        ln -s ${dfuser_files[$key]} $DFUSER_DIR/$key
        dfuser_files_enabled[$key]=${dfuser_files[$key]}
    else
        echo "File not found: ${dfuser_files[$key]}"
    fi
}

# Initialized dfuser_files_enabled from symbolic links
function initialize_dfuser_files() {
    get_dfuser_files;
    for f in $(find $DFUSER_DIR -type l); do
        fn=$(basename $f)
        dfuser_files_enabled[$fn]=$(readlink -f $f)
    done
}

function disable_dfuser_file() {
    local key=$1
    # Check if key ${dfuser_files[$key]} exists
    if [[ -e ${dfuser_files[$key]} ]]; then
        echo "Disabling $key"
        rm $DFUSER_DIR/$key
        unset dfuser_files_enabled[$key]
    else
        echo "File not found: ${dfuser_files[$key]}"
    fi
}

function show_active_dfuser_files() {
    for key in "${!dfuser_files_enabled[@]}"; do
        echo $key " ➡️ " ${dfuser_files_enabled[$key]}
    done
}

function get_dfuser_file() {
    local file=$1
    if [[ -e $file ]]; then
        echo $file
    else
        echo "File not found: $file"
        return 1
    fi
}

## dfbin functions

declare -A dfbin_files
declare -A dfbin_files_enabled

function get_dfbin_files() {
    files=$(find $DFBIN_DIR -name "*.sh" | sort)
    for f in $files; do
        fn=$(basename $f)
        dfbin_files[$fn]=$f
    done
}

function show_dfbin_files() {
    get_dfbin_files
    for key in "${!dfbin_files[@]}"; do
        if [[ -v dfbin_files_enabled[$key] ]]; then
            echo $key " ➡️ " ${dfbin_files[$key]} " ✅"
        else
            echo $key " ➡️ " ${dfbin_files[$key]}
        fi
    done
}


function get_dfbin_file() {
    local file=$1
    if [[ -e $file ]]; then
        echo $file
    else
        echo "File not found: $file"
        return 1
    fi
}

function get_documentation_from_file() {
    local file=$1
    if [[ -e $file ]]; then
        cat $file | grep -E "^#"
    else
        echo "File not found: $file"
        return 1
    fi
}

function get_function_definitions_from_file() {
    local file=$1
    # pattern match function and '() {' for all files that are bash scripts, they may not have a .sh extension
    
    if [[ -e $file ]]; then
        cat $file | grep -E "function [a-zA-Z0-9_]+ \(\) \{" | sed -E "s/function ([a-zA-Z0-9_]+) \(\) \{/\1/"
    else
        echo "File not found: $file"
        return 1
    fi
}




function get_file_env_set() {
    local file=$1
    if [[ -e $file ]]; then
        cat $file | grep -E "^export [a-zA-Z0-9_]+=" | sed -E "s/export ([a-zA-Z0-9_]+)=.*/\1/" | sort | uniq
    else
        echo "File not found: $file"
        return 1
    fi
}

function get_file_env_value() {
    local file=$1
    local var=$2
    if [[ -e $file ]]; then
        cat $file | grep -E "^export $var=" | sed -E "s/export $var=(.*)/\1/"
    else
        echo "File not found: $file"
        return 1
    fi
}

function restore_path_from_dfuser_files() {
    local files=$(get_dfuser_files)
    temp_path=""
    for f in $files; do
        # echo "Processing $f"
        fileset=$(get_file_env_set $f)
        for var in $fileset; do
            if [[ $var == "PATH" ]]; then
                tmp_path="$(get_file_env_value $f $var)"
                temp_path="${temp_path}:${tmp_path}"
            fi
        done
    done

    # Split by : and remove empty strings
    temp_path=$(echo $temp_path | tr ":" "\n" | grep -v "^$")
    # Remove quotes
    temp_path=$(echo $temp_path | sed -E "s/\"//g")
    IFSSAVE=$IFS
    # default IFS
    DIFS=$' \t\n'
    IFS=$' '
    # Make unique
    path_items=()
    for p in $temp_path; do
        # echo $p
        path_items+=($p)
    done
    path_items=($(echo "${path_items[@]}" | tr ' ' '\n' | sort | uniq | grep -v "\\\$PATH"))
    echo ${path_items[@]}
    # remove $PATH from the path_items
    
    IFS=$IFSSAVE
    
}

function split_current_path() {
    echo $PATH | tr ":" "\n"
}

function show_path() {
    echo "Current PATH: "
    split_current_path
}

function check_in_path() {
    local item=$1
    for p in $(split_current_path); do
        if [[ $p == $item ]]; then
            echo "Found $item in PATH"
            return 0
        fi
    done
    echo "Did not find $item in PATH"
    return 1
}

function filter_out_of_path() {
    local item=$1
    local new_path=""
    for p in $(split_current_path); do
        if [[ $p != $item* ]]; then
            new_path="${new_path}:${p}"
        fi
    done
    echo $new_path
}

test_filter_out_of_path() {
    echo "Testing filter_out_of_path"
    echo "Current PATH: "
    split_current_path
    echo "Filtering out /mnt/c/Users/cosgroma/.pyenv/pyenv-win"
    filter_out_of_path "/mnt/c/Users/cosgroma/.pyenv/pyenv-win"
}

function check_if_dir_exists() {
    local dir=$1
    if [[ -d $dir ]]; then
        echo "$dir exists"
    else
        echo "$dir does not exist"
    fi
}

test_check_if_dir_exists() {
    echo "Testing check_if_dir_exists"
    check_if_dir_exists "/home/cosgroma/.pyenv"
    check_if_dir_exists "/mnt/c/Users/cosgroma/.pyenv/pyenv-win2"
}





dfman_dfuser() {
    case $1 in
        "show")
            show_dfuser_files
            ;;
        "enable")
            shift;
            enable_dfuser_file $1
            ;;
        "disable")
            shift;
            disable_dfuser_file $1
            ;;
        "active")
            show_active_dfuser_files
            ;;
        *)
            echo "Usage: dfman user [show|enable|disable|active]"
            ;;
    esac
}

dfman_dfbin() {
    case $1 in
        "show")
            get_dfbin_files
            ;;
        "get")
            get_dfbin_file $2
            ;;
        "doc")
            get_documentation_from_file $2
            ;;
        "functions")
            get_function_definitions_from_file $2
            ;;
        *)
            echo "Usage: dfman bin [show|get|doc|functions]"
            ;;
    esac
}

dfman_env() {
    case $1 in
        "show")
            show_path
            ;;
        "check")
            shift;
            check_in_path $1
            ;;
        "filter")
            shift;
            path_to_filter=$1
            if [[ -z $path_to_filter ]]; then
                echo "Usage: dfman env filter <path>"
                return 1
            fi
            filter_out_of_path $1
            ;;
        "restore")
            restore_path_from_dfuser_files
            ;;
        *)
            echo "Usage: dfman env [show|check|filter|restore]"
            ;;
    esac
}


dfman() {
    case $1 in
        "user")
            dfman_dfuser $2 $3
            ;;
        "bin")
            dfman_dfbin $2 $3
            ;;
        "env")
            dfman_env $2 $3
            ;;
        *)
            echo "Usage: dfman [user|bin|env]"
            ;;
    esac
}

# reload this script into the current shell
function reload_dfman() {
    # clear arrays and other variables
    unset dfuser_files
    unset dfuser_files_enabled
    unset dfbin_files
    unset dfbin_files_enabled
    unset dfuser_files
    unset dfuser_files_enabled
    
    source $HOME/.dfuser/.dfuser_man.sh
}

initialize_dfuser_files;


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