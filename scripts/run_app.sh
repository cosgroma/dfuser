#!/bin/bash
fullfile=$1
filename=$(basename -- "$fullfile")
# extension="${filename##*.}"
# filename="${filename%.*}"
timestamp=$(date +%Y%m%d%H%M%S)
logname=$filename.$timestamp".log"

echo "creating log: " $logname
$fullfile 2>&1 > $logname &
APP_PID=$!
echo $APP_PID > $filename.lock