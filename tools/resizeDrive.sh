#!/bin/bash

mount_dir="/mnt/iscsi"


# Check if the user provided a mount point
if [ $# -eq 1 ]; then
    mount_dir="$1"
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