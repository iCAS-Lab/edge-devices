#!/bin/bash

echo Follow instructions from:

echo "https://www.howtogeek.com/442101/how-to-move-your-linux-home-directory-to-another-hard-drive/"

##### DO NOT RUN THIS SCRIPT #####
echo "DO NOT RUN THIS SCRIPT"
exit

# Find the drive's identifier i.e. /dev/sda etc.
# You may see a different device id like /dev/sdb or /dev/nvme0n1 etc.
sudo fdisk -l

# Partition the drive
sudo fdisk /dev/sda
# 0. Press 'd' and press enter to delete all partitions.
#    Repeat until all partitions have been deleted.
# 1. Press 'g' to initialize the disk to GPT. 
# 2. Press 'p' and confirm there are no partitions.
# 3. Press 'n' to create a new partition and keep use the defaults.
# 4. Press 'w' to write the partition table.

# Confirm the parititon was created.
sudo fdisk -l /dev/sda
# You should see a new partition was created and the partition can be
# accessed via /dev/sda1 or similar.

# Create the file system (Format)
sudo mkfs -t ext4 /dev/sda1

# Mount the drive
sudo mount /dev/sda1 /mnt

# Go to the newly created partition
cd /mnt

# List the contents and delete extra
ls -ahl
sudo rm -rf lost+found

# Copy entire /home directory and preserve the file attributes
sudo cp -rp /home/* /mnt

# Sanity check that everything copied
ls /mnt

# Rename the old home directory
sudo mv /home /home.bak

# Create a new /home directory for /dev/sda1 to be mounted to.
sudo mkdir /home

# Unmount /dev/sda1
sudo umount /dev/sda1

# Mount /dev/sda1 to /home
sudo mount /dev/sda1 /home

# Auto mount /dev/sda1 to /home on boot
sudo cp /etc/fstab /etc/fstab.bak1
sudo vim /etc/fstab
# Add the following line to your /etc/fstab assuming /dev/sda1
# Note: The following is TAB delimited
/dev/sda1 /home ext4  defaults  0 0
