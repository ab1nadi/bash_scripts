#!/bin/bash
#
# Script Name: install_cockpit.sh
#
# Description: This script installs cockpit and some applications for cockpit.
# Then using the settup_NetworkManager.sh script it fixes the network issues that cockpit
# causes with the systemd NetworkManager conflict.
#
# Author: Abinadi Swapp
# Date: March 7, 2024
# Version: 1.0
#
# Usage: sudo ./install_cockpit.sh
#

apt update

# install kvm 
yes | apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm

# get version environment variables
. /etc/os-release

# install cockpit
yes | apt install -t ${VERSION_CODENAME}-backports cockpit

# install cockpit applications
yes | apt install -t ${VERSION_CODENAME}-backports cockpit-storaged
yes | apt install -t ${VERSION_CODENAME}-backports cockpit-networkmanager
yes | apt install -t ${VERSION_CODENAME}-backports cockpit-packagekit
yes | apt install -t ${VERSION_CODENAME}-backports cockpit-machines
yes | apt install -t ${VERSION_CODENAME}-backports cockpit-podman


echo "Done installing cockpit"


./settup_NetworkManager.sh

 