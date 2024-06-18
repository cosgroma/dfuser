# Manages the .dfuser script files
# This script will be sourced by .bashrc
# .bashrc will also source all the files in $HOME/.dfuser if they don't start with a dot or an underscore and end with .sh
# This script will manage how these files will be activated on new shells by managing the names of these files
# This can also do a few other things like:
# * What environment variables are available in the current shell
# It will have an interactive mode for managing the user level scripts which cover activating nvm, conda, etc

DFBIN_DIR=$HOME/.dfbin
DFUSER_DIR=$HOME/.dfuser

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

function get_dfuser_files() {
    find $DFUSER_DIR -name "*.sh" | sort
}

function get_dfbin_files() {
    find $DFBIN_DIR -name "*.sh" | sort
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

function show_active_dfuser_files() {
    echo "dfuser files at $DFUSER_DIR: "
    for f in `get_dfuser_files`; do
        fn=$(basename $f)
        [[ $fn =~ ^_ ]] && {
            echo "[-]" $fn
            } || {
            echo "[+]" $fn
        };
    done;
}

function disable_dfuser_file() {
    local file=$1
    local base=$(basename $file)
    local newfile=$DFUSER_DIR/_$base
    mv $file $newfile
    echo "Disabled $file"
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

test_filter_out_of_path() {
    echo "Testing filter_out_of_path"
    echo "Current PATH: "
    split_current_path
    echo "Filtering out /mnt/c/Users/cosgroma/.pyenv/pyenv-win"
    filter_out_of_path "/mnt/c/Users/cosgroma/.pyenv/pyenv-win"
}

# Declare an associative array
declare -A emojis

# Add more emojis
function add_emojis_json() {
  local json_file="$1"
  while IFS="=" read -r key value
  do
    emojis[$key]=$value
  done < <(jq -r "to_entries|map(\"\(.key)=\(.value)\")|.[]" $json_file)
}

test_add_emojis_json() {
  add_emojis_json "emojis.json"
  for key in "${!emojis[@]}"
  do
    echo "$key: ${emojis[$key]}"
  done
}


# Function to use emojis
function print_emoji() {
  local name="$1"
  echo "${emojis[$name]}"
}

function print_all_emojis() {
  for key in "${!emojis[@]}"
  do
    echo "$key: ${emojis[$key]}"
  done
}

# Export function if you plan to source this script and use it in other scripts
export -f print_emoji
