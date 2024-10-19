#!/bin/bash

# Check env for KB_ROOT
if [ -z "$KB_ROOT" ]; then
    KB_ROOT=/mnt/h/kb
    echo "KB_ROOT not set: setting to $KB_ROOT"    
fi

PID_DIR=${KB_ROOT}/pids

function dir_scan(){

    target_directory=$1

    # get absolute path
    target_directory=$(realpath $target_directory)

    if [ -z "$target_directory" ]; then
        echo "Usage: $0 <target_directory>"
        return 1
    fi

    if [ ! -d "$target_directory" ]; then
        echo "Target directory does not exist: $target_directory"
        return 1
    fi

    # make sure PID_DIR exists
    if [ ! -d "$PID_DIR" ]; then
        mkdir -p $PID_DIR
    fi

    # replace / with - in target_directory
    output_log_file="${KB_ROOT}/sgt-kb_${target_directory//\//-}_files.log"
    output_json_file="${KB_ROOT}/sgt-kb_${target_directory//\//-}_files.json"

    ( sgt-kb -f $output_json_file $target_directory > $output_log_file 2>&1 ) &
    echo $! > ${PID_DIR}/sgt-kb_${target_directory//\//-}_files.pid
}

# get if pids are running
function get_pids(){
    pids=$(ls ${PID_DIR}/*.pid 2>/dev/null)
    if [ -z "$pids" ]; then
        echo "No pids found"
        return 1
    fi
    IFSSAVE=$IFS
    IFS=$'\n'
    for pid in ${pids[@]}; do
        pid_file=$(basename $pid)
        pid=$(cat $pid)
        if [ -d /proc/$pid ]; then
            echo "$pid_file is still running"
        else
            # remove pid file
            echo "$pid_file removing pid file"
            rm ${PID_DIR}/$pid_file
        fi
    done
    IFS=$IFSSAVE
}

# get list of home directories
# users=$( (find /home -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort | xargs -i id {} 2>&1) | grep '^uid=' | cut -d'(' -f2 | cut -d')' -f1 )
# 
function scan_many(){
    root_dir=$1
    if [ -z "$root_dir" ]; then
        echo "Usage: $0 <root_dir>"
        return 1
    fi
    if [ ! -d "$root_dir" ]; then
        echo "Root directory does not exist: $root_dir"
        return 1
    fi
    dirs=$(find $root_dir -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort)
    IFSSAVE=$IFS
    IFS=$'\n'
    for dir in ${dirs[@]}; do
        directory="${root_dir}/${dir}"
        echo "Starting scan of $directory"
        dir_scan $directory
    done
    IFS=$IFSSAVE
}

root_dir="/mnt/e/.backups"