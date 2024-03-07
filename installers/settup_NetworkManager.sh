#!/bin/bash
#
# Script Name: settup_NetworkManager.sh
#
# Description: This script disables netwokd and enables NetworkManager .
#
# Author: Abinadi Swapp
# Date: March 7, 2024
# Version: 1.0
#
# Usage: sudo ./settup_NetworkManager.sh
#

echo "Enabling NetworkManager and disabling networkd"

# add network manager
# if it isn't already there
apt update
apt-get install network-manager

# stop networkd
systemctl stop systemd-networkd
systemctl disable systemd-networkd


# start network manager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "Done with network"