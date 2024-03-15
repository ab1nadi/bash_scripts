#!/bin/bash
#
# Script Name: connect_nas.sh
#
# Description: Runs iscsiadm to connect this ubuntu server to an NAS.
#
# Author: Abinadi Swapp
# Date: March 7, 2024
# Version: 1.0
#
# Usage: sudo ./install_cockpit.sh
#


# variables that are settup by the installer
ip="10.29.254.19"
targets=( "iqn.2005-10.org.freenas.ctl:fortistuff-zvol")
mounts=( "/mnt/forti")
declare -A map

echo "______________ CONNECTING NAS _______________"

if [[ "$ip" = "NULL" || "$target" = "NULL" || "$mntPoint" = "NULL" ]]; then
    echo "Please set variables"
    exit 1
fi


echo "Mapping targets to mounts"
for ((i=0; i<${#targets[@]}; i++)); do
    map["${targets[$i]}"]="${mounts[$i]}"
done



echo "Connecting to targets on NAS:"

for target in "${targets[@]}"; do
    echo "connect to $target"
    iscsiadm --mode node --targetname $target --portal "$ip:3260" --login
done

echo "Mounting targets:"
# Run iscsiadm to get session information
session_info=$(sudo iscsiadm -m session -P 3)

# Parse the output using awk and grep
target_names=($(echo "$session_info" | awk '/Target:/{print $2}'))
device_paths=($(echo "$session_info" | awk '/Attached scsi disk/{print $4}'))

mountoutput=""

# Display the mapping
for ((i=0; i<${#target_names[@]}; i++)); do
     path="${target_names[$i]}"
     echo -e "Mounting /dev/${device_paths[$i]} =>  ${map[$path]}"
     mount "/dev/${device_paths[$i]}" "${map[$path]}"
done

if [ -n "$mountoutput" ]; then
    echo "** There may have been an issue mounting some of these drives **"
    echo "Please view the previous output; you may need to investigate further."
    echo "$mountoutput"
fi
echo "______________ DONE CONNECTING NAS _______________"




