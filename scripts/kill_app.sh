#!/bin/bash
fullfile=$1
filename=$(basename -- "$fullfile")
# filename="${filename%.*}"
APP_PID=$(cat $filename.lock)
kill $APP_PID
rm $filename.lock