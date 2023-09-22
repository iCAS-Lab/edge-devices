# Edge ML Accelerators

This repository contains the code, scripts, and Dockerfiles for setting up different edge machine learning accelerators on different platforms.

## Required Software:

- A computer with an Intel/AMD x86-64 CPU running a 64-bit version of Linux with sudo priveleges (other OSes not tested).
- [Docker](https://docs.docker.com/engine/install/)

  - See [A Note on Docker](#a-note-on-docker) and [Installing Docker](#installing-docker)
  - For the Intel NCS2, Google Coral Edge TPU, and flashing the NVIDIA Jetson Nano.
  - Optional to install on Raspberry Pi.
  - Installed by default on Jetson Nano via SDK Manager.

- Internet Access to install software dependencies.

## Required Hardware:

Each device has its own requirements for cables, power supplies, and etc. These are listed in the `Required Hardware` sections of each device. The following are general requirements:

- Mouse, keyboard, and monitor (Raspberry Pi and Jetson Nano)
- A host computer with a CPU (Intel NCS2 and Google Coral Edge TPU)

## Device Setup Documentation

- [coraltpu](./coraltpu) - Google Coral Edge TPU setup instructions.
- [jetson](./jetson) - NVIDIA Jetson Nano (2GB and 4GB) setup instructions.
- [ncs2](./ncs2/) - Intel Neural Computer Stick 2 setup instructions.
- [raspberrypi](./raspberrypi) - Raspberry Pi setup instructions.

## A Note on Docker

Docker is a containerization software that is able to isolate applications and even operating systems. The idea of containers is similar to a Virtual Machine (VM), but without the hypervisor i.e. emulating the hardware which resource demanding. Instead, containers are able to directly work with the computer's hardware and kernel for making more efficient use of system resources than a VM.

Theoretically, all of these devices should work independent of using Docker and in many cases we observed they could. However, for the simplest setup, we recommend using Docker to prevent compatibility issues with your host computer's OS.

Many of the devices require sudo priveleges to install packages and to access the hardware directly. Thus, when running the docker image many of the commands use the `--priveleged` flag. **_Using this flag can have certain negative security implications._** Please use this with care.

## Docker Cheat Sheet

For basic docker CLI commands, users can refer to the [Docker Cheat Sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf).

Here are a couple basic commands:
```shell
# Download a docker image from dockerhub.com
docker pull <repo>/<image_name>:<tag>
# List your local images
docker images
# List your local containers
docker container ls -a
# Run a docker image for the first time and create a named container
docker run --name <desired_name> -ti <docker_image> <command_to_run_in_container>
# Stop a docker container
docker stop <container_name>
# Start a docker container. ONLY RUN THIS ONCE
docker start -ai <container_name>
# Execute a command inside of the docker container
docker exec -ti <container_name> <command>
# Open a new bash shell in docker container
docker exec -ti <container_name> /bin/bash
# Copy between docker container and host
docker cp <host_filepath> <container_name>:<container_path>
docker cp <container_name>:<container_filepath> <host_path>
```

## Installing Docker

Use the instructions from Docker's official documentation to install docker on your computer.

- Ubuntu:

  - https://docs.docker.com/engine/install/ubuntu/

- All other OS's:
  - https://docs.docker.com/get-docker/

Be sure to run `sudo docker run hello-world` to be sure your docker install was successful.

**_Note: You may need to use `sudo docker` to elevate permission on some OSes. You can avoid using `sudo` by adding your username to the `docker` group via the following command and logging out and back in:_**

```shell
sudo usermod -aG docker username
```
