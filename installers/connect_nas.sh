#!/bin/bash

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
