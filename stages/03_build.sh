#!/usr/bin/env bash

# Script to process unzipped files and build parquet files

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Set list path
listpath="$localpath/list"
mkdir -p $listpath
echo "List path: $listpath"

# Set raw path
export rawpath="$localpath/raw"
echo "Raw path: $rawpath"

# Create brick directory
export brickpath="$localpath/brick"
mkdir -p $brickpath
echo "Brick path: $brickpath"

# Process raw files and create parquet files in parallel
# calling a Python function with arguments input and output filenames
cat $listpath/raw_files.txt | xargs -P1 -n1 bash -c '
  filename="${0%.*}"
  echo $rawpath/$0
  echo $brickpath/$filename.parquet
  python stages/csv2parquet.py $rawpath/$0 $brickpath/$filename.parquet
'
