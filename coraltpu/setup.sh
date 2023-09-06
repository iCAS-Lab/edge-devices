#!/bin/bash

sudo apt update
sudo apt upgrade -y

################################################################################
# Install Coral TPU
################################################################################
### Add Coral TPU keys
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
################################################################################
# Update the repository with the new keys
sudo apt update
# Install the libs and python3 interface
sudo apt-get install libedgetpu1-std python3-pycoral -y