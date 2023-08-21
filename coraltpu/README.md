# Google Coral Edge TPU

Like the other devices we recommend using Docker to containerize this device's environment.

## 0. Preliminaries

### Required Software

It is **_HIGHLY_** recommended to use Docker to use the Coral Edge TPU to avoid installing installing the dependencies/packages on your host machine and possibly causing library/package conflicts. Docker isolates applications and/or operating systems from your host machine without much performance loss.

- [Docker](https://docs.docker.com/engine/install/) - Install for Linux, use the `server` installation instructions. Only Docker Engine is needed, Docker Desktop is optional. For example, for installation on Ubuntu use the [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) instructions.

### Required Hardware

- The Coral Edge TPU comes in two primary form factors that are commercially available from [here](https://coral.ai/products/). We have validated the following process on the USB form factor, but the process for other form factors should be similar. You will need to purchase one of the following devices:
  - [USB Accelerator](https://coral.ai/products/accelerator)
  - [Dev Board](https://coral.ai/products/dev-board) - 1GB and 4GB memory options available.
- Host computer with a CPU and a Linux-based OS installed.

# Using via Docker (Recommened)

## 1. Download the Docker Image

Run the following command to pull the pre-configured Docker image:

```shell
docker pull s7117/ubuntu-coraltpu:latest
```

This Docker image contains the necessary packages pre-installed to run models on the Coral Edge TPU. For more details on what the image currently contains, see the Dockerfile [here](https://github.com/s7117/docker-envs/blob/main/coraltpu/Dockerfile).

## 2. Using the Docker Image

To use the Docker image run the following command replacing `container_name` and `hostname` with your desired strings (i.e. coraltpu or etc.).

```shell
docker run --privileged -v /dev/bus/usb:/dev/bus/usb --name container_name --hostname hostname -ti s7117/ubuntu-coraltpu
```

## 3. Copying to/from Docker Container

To copy a ML model or file(s) to the Docker container (i.e. named whatever you replaced `container_name` with in the above command) use the following command:

```shell
# This command copies a PyTorch model from the current directory on the
# host computer into the container named container_name to the
# /home/user directory
docker cp ./model.pt container_name:/home/user
```

To copy a file from the Docker container use something like:

```shell
# This command copies a PyTorch model from the Docker container
# to your home directory (~) on your host machine.
docker cp container_name:/home/user/model.pt ~
```

# Using on Host

If you would like to install the Coral Edge TPU dependencies and libaries on your local host machine, simply run the [setup.sh](./setup.sh) bash script.
