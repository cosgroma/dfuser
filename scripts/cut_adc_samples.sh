#!/bin/bash

# Check if the correct number of arguments is given
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <filename> <sample_rate> <milliseconds>"
    exit 1
fi

# Assign arguments to variables
filename=$1
sample_rate=$2
milliseconds=$3

# Calculate the number of bytes per sample (4 channels * 1 byte per channel)
bytes_per_sample=4

# Calculate the number of samples per millisecond
samples_per_millisecond=$(echo "scale=2; $sample_rate / 1000" | bc)

# Calculate the total number of bytes per millisecond
bytes_per_millisecond=$(echo "$samples_per_millisecond * $bytes_per_sample" | bc)

# Calculate the total number of bytes to extract for the given milliseconds
total_bytes=$(echo "$bytes_per_millisecond * $milliseconds" | bc)

# Use 'dd' to extract the integer number of bytes from the binary file
# dd if="$filename" of="${filename}_cut" bs=1 count=$total_bytes

dd if=/media/sas1/data/mcode_8bit_4chan.bin of=./data/mcode_8bit_4chan_1min.bin bs=1 count=13516800000

echo "Extracted $total_bytes bytes into ${filename}_cut"