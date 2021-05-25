#!/bin/sh
sudo apt-get update
sudo apt dist-upgrade -y
sudo apt-get install -y python wget
sudo sleep 10;

# Format attached disks
sudo mkfs.ext4 /dev/xvdh

# Create folders & mount disks
sudo mkdir -p /mnt/influxdb/data
sudo mount /dev/xvdh /mnt/influxdb/data

# Create script to mount disks at startup
echo 'echo # influxdb-data-disk >> /etc/fstab' >> /tmp/disks.sh
echo 'echo /dev/xvdh    /mnt/influxdb/data    ext4    defaults    0    2 >> /etc/fstab' >> /tmp/disks.sh

# Mount disks at startup
sudo bash /tmp/disks.sh

# Download, install and start InfluxDB data-nodes
sudo wget -O /tmp/influxdb-data_1.8.6-c1.8.6_amd64.deb https://dl.influxdata.com/enterprise/releases/influxdb-data_1.8.6-c1.8.6_amd64.deb
sleep 5;
sudo dpkg -i /tmp/influxdb-data_1.8.6-c1.8.6_amd64.deb
sleep 5;
sudo systemctl start influxdb