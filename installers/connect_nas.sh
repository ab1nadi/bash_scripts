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

echo "script not ready yet"
exit 0


# install iscsi
apt-get update
apt-get install open-iscsi


iscsiadm -m discovery -t sendtargets -p 10.29.254.19



iscsiadm -m node -T TARGET_NAME -p 10.29.254.19:3260 --login


fdisk -l




sudo mkdir /mnt/iscsi
sudo mount /dev/sdX /mnt/iscsi
