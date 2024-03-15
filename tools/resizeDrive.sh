#!/bin/bash
#
# Script Name: resizeDrive.sh
#
# Description: Runs resize 2fs on a mounted file system.
# If you run the script without args it will resize the last passed mount point.
#
# Author: Abinadi Swapp
# Date: March 15, 2024
# Version: 1.0
#
# Usage: sudo ./resizeDrive.sh 
# or 
#        sudo ./resizeDrive.sh /mount/point
#


./vars.sh # load variables
source ../lib/functions.sh # load helper functions


# Check if the user provided a mount point
if [ $# -eq 1 ]; then
    mount_dir="$1"

    echo "Updating the mount_dir variable so next time you can just run this command without args" 

    #call setvar helper function
    setVar vars.sh mount_dir $mount_dir
fi


git clone https://github.com/ab1nadi/bash_scripts.git


echo -n  "Are you sure you want to resize the file system mounted on $mount_dir? y for yes:"
read answer


# Exit if they really didn't want to resize the drive
if [[ !  "$answer" =~ ^[Yy](es)?$ ]]; then
    echo "You chose to stop."
    exit 0
fi


# Get the device
device=$(df -h | grep "$mount_dir" | awk '{print $1}')


echo "Resizing $device mounted to $mount_dir"

# resize the device
resize2fs "$device" 

# resize2fs will output any errors it encounters.