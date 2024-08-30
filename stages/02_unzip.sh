#!/usr/bin/env bash

# Script to unzip files

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Set download path
export downloadpath="$localpath/download"
echo "Download path: $downloadpath"

# Set list path
listpath="$localpath/list"
echo "List path: $listpath"

# Create raw path
export rawpath="$localpath/raw"
mkdir -p $rawpath
echo "Raw path: $rawpath"

# Unzip files in parallel
cat $listpath/downloaded_files.txt | xargs -P10 -n1 bash -c '
  filename="${0%.*}"
  echo $downloadpath/$0
  echo $rawpath/$filename
  gunzip -c $downloadpath/$0 > $rawpath/$filename
'

# List unzipped files
find $rawpath -type f -name "*"  -exec basename {} \; > $listpath/raw_files.txt

# Fix header of chemical.sources.v5.0.tsv adding a missing column "source_id"
sed -i '1s/$/\tsource_id/' $rawpath/chemical.sources.v5.0.tsv
