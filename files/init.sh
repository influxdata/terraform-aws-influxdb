#!/bin/sh
sudo apt-get update
sudo apt-get install -y python

# Format attached disks
lsblk /dev/xvdh
if [[ $? -eq 0 ]]; then
    mkfs.ext4 /dev/xvdh
fi
