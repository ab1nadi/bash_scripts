#!/bin/bash

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


echo "Done"


 