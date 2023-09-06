#!/bin/bash

# Download docker image
# Download the docker image from:
echo "Download the Ubuntu 18.04 SDK Manager Docker Image:"
echo "https://developer.nvidia.com/drive/sdk-manager"

##### DO NOT RUN THIS SCRIPT #####
echo "DO NOT RUN THIS SCRIPT"
exit

# Load docker image into docker
docker load -i ~/Downloads/sdkmanager-1.9.2.10884-Ubuntu_18.04_docker.tar.gz

# Tag the docker image
docker tag sdkmanager:1.9.2.10884-Ubuntu_18.04 sdkmanager:18.04

##### IMPORTANT #####
# Run lsusb and confirm that NVIDIA Corp. APX shows up.
sudo lsusb
read CONT

# Flash Using the Docker image
# Accept all agreements

docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --name JetPack_NX_Devkit --network host sdkmanager:18.04 --cli install --logintype devzone --product Jetson --version 4.6.3 --targetos Linux --host --target JETSON_NANO_TARGETS --flash all --select 'Jetson OS'

# While the packages are being dowloaded run the follwoing command to ensure that the container see the Nvidia Corp. device
docker exec -ti JetPack_NX_Devkit lsusb

# Run the following command to save the container from the docker run command into a new image
docker commit JetPack_NX_Devkit jetpack_nx_devkit:flashed

# You can delete the container now after commiting the container into an image.
docker container rm JetPack_NX_Devkit

# Next time you need to flash you can simply run:
docker run -it --rm --privileged -v /dev/bus/usb:/dev/bus/usb/ jetpack_nx_devkit:flashed