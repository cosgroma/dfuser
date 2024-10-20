#!/bin/bash

# This script is used to backup the source code of a SERGEANT Design and make a tar.gz file at <sgt_designS_dir>/<design_name>/backup/sgt-src.tar.gz

# SERGEANT Design Dir
SGT_DESIGNS_DIR=$HOME/workspace/sergeant/designs

# SERGEANT Design Name
SGT_DESIGN_NAME=$1

# Check if the design name is provided
if [ -z "$SGT_DESIGN_NAME" ]; then
    echo "Please provide the design name"
    exit 1
fi

# Check if the design exists
if [ ! -d "$SGT_DESIGNS_DIR/$SGT_DESIGN_NAME" ]; then
    echo "Design $SGT_DESIGN_NAME does not exist"
    exit 1
fi

DESIGN_DIR=$SGT_DESIGNS_DIR/$SGT_DESIGN_NAME


src_search_set="-name *.c -o -name *.h"

SRC_FILE_KIND_ADD_LIST=(
'.h'
'.cpp'
'.hpp'
'.mk'
'.sh'
'.py'
'.tcl'
'.v'
'.vhdl'
'.xml'
'.sv'
)
# turn glob off
set -f
for kind in ${SRC_FILE_KIND_ADD_LIST[@]}; do 
    add_str=" -o -name *$kind"
    # Append the string to the src_search_set
    src_search_set=$src_search_set$add_str
done;

# echo $src_search_set

find $DESIGN_DIR $src_search_set | tar -czf $DESIGN_DIR/sgt-src.tar.gz -T -