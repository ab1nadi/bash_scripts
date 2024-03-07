#!/usr/bin/env bash
#
# Script Name: install_cockpit.sh
#
# Description: Future plans for this script are to automatically settup a NAS on 
# an ubuntu server. Right now it doesn't work, I need to find a way to parse the device name from fdisk. 
#
# Author: Abinadi Swapp
# Date: March 7, 2024
# Version: 1.0
#
# Usage: sudo ./install_cockpit.sh
#



# sets a variable in 
# any given file 
function setVar() {
    local file="$1"
    local variable="$2"
    local value="$3"
    
    # Use awk to update the variable value in a temporary file
    awk -v var="$variable" -v val="$value" 'BEGIN { FS = "=" } $1 == var {print var "=" val; next} {print $0}' "$file" > "$file.tmp"

    # Replace the original file with the updated content
    mv "$file.tmp" "$file"
}

# backups a file 
function backup() {
    local file="$1"

    cp $file "$file.backup"
}

# variables
iscsiconf="/etc/iscsi/iscsid.conf"
ip="10.29.254.19"
mount="/mnt/iscsi"
targetname=""
target=""

# parse some variables passed as args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -ip)
      ip="$2"
      shift 2
      ;;
    -mt)
      mount="$2"
      shift 2
      ;;
    *)
      targetname="$1"
      shift
      ;;
  esac
done

# The target name of the zvolume
if [ -z "$targetname" ]; then
  echo "Please provide a NAS target name."
  exit 0
fi

# create mount directory if it doesnt already exist
mkdir $mount


target=iscsiadm -m discovery -t sendtargets -p "$ip" | awk -v targ="$targetname" '$2 ~ targ {print $2}'



# set the variables in the connect_nas script
setVar ../helper_scripts/connect_nas.sh ip $ip
setVar ../helper_scripts/connect_nas.sh target $target
setVar ../helper_scripts/connect_nas.sh mount $mount

