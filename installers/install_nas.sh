#!/bin/bash
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

# get helper functions for writing variables in other files
source ../lib/functions.sh


# variables
ad_dir="/usr/local/bin"
cron="@reboot $ad_dir/connect_nas.sh"
ip="10.29.254.19"
mounts=()
targetnames=()
targets=()

while getopts ":i:m:t:" opt; do
  case $opt in
    i) ip="$OPTARG";;
    m) mounts+=("$OPTARG");;
    t) targetnames+=("$OPTARG");;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
  esac
done

# Print the values for demonstration purposes


echo "Creating mount points:"
for mount in "${mounts[@]}"; do
  if test -d $mount; then
    echo -e "$mount \t=> already exists."
  else 
      mkdir $mount
      echo -e "$mount /t=> created."
  fi
done


echo "Getting targets:"
# iterate over given target names 
for name in "${targetnames[@]}"; do
    # Perform iSCSI discovery and filter targets using awk
    discovered_targets=($(iscsiadm -m discovery -t sendtargets -p "$ip" | awk -v targ="$name" '$2 ~ targ {print $2}'))

    # Check if any targets were discovered and append to the targets array
    if [ ${#discovered_targets[@]} -gt 0 ]; then
        targets+=("${discovered_targets[0]}")

        echo -e "$name \t=> ${discovered_targets[0]} "
    fi
done



# set the variables in the connect_nas script
setVar ../helper_scripts/connect_nas.sh ip $ip
setVarArray ../helper_scripts/connect_nas.sh mounts "${mounts[@]}"
setVarArray ../helper_scripts/connect_nas.sh targets "${targets[@]}"



# run the nas
echo "Connecting nas for the first time!"

# run the connect nas script 
./../helper_scripts/connect_nas.sh


echo "Putting script for cron in /usr/local/bin:"
# copy the connect nas script into /usr/local/bin
# then it can be run as a cron job
cp ../helper_scripts/connect_nas.sh "$ad_dir/connect_nas.sh"


echo "Adding script to crontab:" 
# Check if the cron entry already exists
if ! (crontab -l | grep -q "$cron"); then
    # If it doesn't exist, echo the new command and pipe it to crontab for the root user
    echo "$cron" | crontab -
    echo "Cron entry added successfully."
else
    echo "Cron entry already exists."
fi