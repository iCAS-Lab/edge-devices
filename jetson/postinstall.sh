#!/bin/bash

# Disable GUI
sudo systemctl set-default multi-user.target

# Disable Docker
sudo systemctl disable docker
sudo systemctl disable docker.socket
sudo systemctl disable containerd

# Update APT Repositories
sudo apt-get update -y

# Install/Setup UFW
sudo  apt-get install ufw
sudo systemctl enable ufw
sudo sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
sudo ufw enable
sudo ufw default deny
sudo ufw allow 222

# Upgrade the OS and packages in APT
sudo apt-get upgrade -y

# Configure Extra Swap
# TODO

# Change Memory Size
# TODO

# Configure SSH
sudo sed -i 's/#Port 22/Port 222/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
echo 'AllowUsers icas' | sudo tee -a  /etc/ssh/sshd_config
echo 'DenyUsers root' | sudo tee -a  /etc/ssh/sshd_config

# Install other tools
sudo apt-get install htop usbutils lm-sensors wget curl

# Install Miniforge3
if [[ ! -d "~/.miniforge3" ]]; then
    MF3_PATH="$HOME/.miniforge3"
    echo "LOG --> Installing Miniforge3..."
    mkdir -p $MF3_PATH
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    chmod 700 "./Miniforge3-$(uname)-$(uname -m).sh"
    ./Miniforge3-$(uname)-$(uname -m).sh -b -p $MF3_PATH -f
    rm ./Miniforge3*
    $MF3_PATH/bin/conda init zsh
fi

# Configure SSH
mkdir -p ~/.ssh
mkdir -p ~/.ssh/github
touch ~/.ssh/config
echo 'Host github.com' | tee -a ~/.ssh/config
echo -e '\tPreferredAuthentications publickey' | tee -a ~/.ssh/config
echo -e '\tIdentityFile ~/.ssh/github/id_ed25519' | tee -a ~/.ssh/config 
ssh-keygen -t ed25519 -a 203 -f ~/.ssh/github/id_ed25519