#!/bin/bash

# mongoexport --uri=$MONGODB_URI  --username=root --password=example  --db=$database --collection=$collection --out=$SGT_KB_FILE

# mongoexport --uri="mongodb://magellan:28044/" --username=root --password=example --authenticationDatabase=admin --db=cosgrma --collection=info --out=/home/$USER/workspace/sergeant/.sgt-kb/cosgrma-info.json

# MONGODB_URI="mongodb://magellan:28044/"
# database="cosgrma"
# collection="info"
# output_file=$database-$collection.json

if [ -z "$MONGODB_URI" ]; then
    echo "MONGODB_URI is not set"
    export MONGODB_URI="mongodb://root:example@magellan:28044/"
    echo "Using $MONGODB_URI"
fi

MONGO_AUTH="--username=root --password=example --authenticationDatabase=admin"
function mdb_export() {
    local database=$1
    local collection=$2
    local output_file=$database-$collection.json
    local SGT_KB_DIR="/home/$USER/workspace/sergeant/.sgt-kb"
    local SGT_KB_FILE="$SGT_KB_DIR/$output_file"
    echo "Exporting $database/$collection to $SGT_KB_FILE"
    mongoexport --uri=$MONGODB_URI $MONGO_AUTH --db=$database --collection=$collection --out=$SGT_KB_FILE
}


function mdb_stat() {
    local database=$1
    # local collection=$2
    # local output_file=$database-$collection.json
    # local SGT_KB_DIR="/home/$USER/workspace/sergeant/.sgt-kb"
    # local SGT_KB_FILE="$SGT_KB_DIR/$output_file"
    # echo "Status of $database/$collection"
    mongostat --uri=$MONGODB_URI $MONGO_AUTH --all
}

mdb_export "cosgrma" "info"
mdb_stat "cosgrma"