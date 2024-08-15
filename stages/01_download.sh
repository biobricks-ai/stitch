#!/usr/bin/env bash

# Script to download files
# Download page http://stitch.embl.de/cgi/download.pl
# We get all .tsv.gz files to download
# Example address http://stitch.embl.de/download/chemical_chemical.links.v5.0.tsv.gz

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Create the list directory to save list of remote files and directories
listpath="$localpath/list"
echo "List path: $listpath"
mkdir -p $listpath
cd $listpath;

# Define the download page
export baseaddress="http://stitch.embl.de"
export downloadpage="$baseaddress/cgi/download.pl"
export downloadbase="$baseaddress/download/"

# Retrieve the list of files to download from FTP base address
wget --no-remove-listing $downloadpage
# cat download.pl | grep -Po '(?<=href=")[^"]+\.tsv\.gz' | sed 's|/download/||g'  > files.txt
cat download.pl | grep -Po '(?<=href=")[^"]+\.tsv\.gz' | sed 's|/download/||g' | head -n 2 > downloaded_files.txt
rm download.pl

# Create the download directory
export downloadpath="$localpath/download"
echo "Download path: $downloadpath"
mkdir -p "$downloadpath"
cd $downloadpath;

# Download files in parallel
cat $listpath/downloaded_files.txt | xargs -P14 -n1 bash -c '
  echo $0
  wget -nH -q -nc -P $downloadpath $downloadbase$0
'

echo "Download done."
