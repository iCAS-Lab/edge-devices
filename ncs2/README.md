# Intel Neural Compute Stick 2

## (DISCONTINUED - June 2023)

From Intel:

```
Developers still working with the Intel NCS2 are advised to transition to the Intel® Edge AI box for video analytics, which offers hardware options to support your needs.
```

```
* The last order date for the Intel NCS2 was February 28, 2022.
* Technical support will continue until June 30, 2023.
* Warranty support will continue until June 30, 2024.
```

```
The Intel® Distribution of OpenVINO™ toolkit will continue to support the Intel NCS2 until version 2022.3, at which point the Intel NCS2 support will be maintained on the 2022.3.x Long-Term Support (LTS) release track.
```

This guide describes how to get up and running with the OpenVINO toolkit using docker.

## 0. Preliminaries

### Required Software

It is **_HIGHLY_** recommended to use Docker to use the Coral Edge TPU to avoid installing installing the dependencies/packages on your host machine and possibly causing library/package conflicts. Docker isolates applications and/or operating systems from your host machine without much performance loss.

- [Docker](https://docs.docker.com/engine/install/) - Install for Linux, use the `server` installation instructions. Only Docker Engine is needed, Docker Desktop is optional. For example, for installation on Ubuntu use the [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) instructions.

### Required Hardware

- Intel Neural Computer Stick 2
  - Officially Discontinued by [Intel](https://www.intel.com/content/www/us/en/developer/articles/tool/neural-compute-stick.html)
  - Available from third-party sellers on Amazon and eBay
- Host computer with a CPU and a Linux-based OS installed.

## 1. Downloading OpenVINO

The docker images for OpenVINO are located:  
https://hub.docker.com/u/openvino

Use:  
`docker pull openvino/ubuntu20_data_dev:latest`

This command will pull the image from docker hub to your local machine.

## 2. Using the container

To run the container the first time run:

```shell
docker run -it --rm openvino/ubuntu20_data_dev:latest
```

This command will enter you into a bash terminal. You should see that your terminal's prompt says `openvino@<hostname>:<path>$`. If you see this you have successfully ran the container and the container has launched an interactive bash terminal.

You will notice that by default the container enters you into `/opt/intel/openvino_<year>.<version>/`. This is where the OpenVINO install is located.

To pass in the device you simply need to pass in the device inside of the `docker run` command:

_For example_:

Use the following command exactly to use OpenVINO with NCS2:

```shell
docker run -it -u 0 --name myriad --hostname openvinomyriad --device /dev/dri:/dev/dri --device-cgroup-rule='c 189:* rmw' -v /dev/bus/usb:/dev/bus/usb openvino/ubuntu20_data_dev:latest
```

**_Note: Using the `--rm` flag when running the container deletes the container after exiting the run._**

Source: https://hub.docker.com/r/openvino/ubuntu20_data_dev

## 3. Test the OpenVINO Container

The following link downloads the GoogleNet-v1, optimizes it, and runs it on the Intel NCS2.

1. Update the system.

```shell
sudo apt update -y && apt upgrade -y
```

2. Locate the model downloader.

```shell
cd /opt/intel/openvino_2021.*/deployment_tools/open_model_zoo/tools/downloader
```

3. Download a sample model

```shell
python3 downloader.py --name googlenet-v1 -o ~
```

4. Run the model optimizer.

```shell
python3 /opt/intel/openvino_2021.*/deployment_tools/model_optimizer/mo.py --input_model ~/public/googlenet-v1/googlenet-v1.caffemodel --data_type FP32 --output_dir ~
```

5. Run the model on the NCS2.

```shell
python3 /opt/intel/openvino_2021/deployment_tools/tools/benchmark_tool/benchmark_app.py -m ~/googlenet-v1.xml -d MYRIAD -api async -i /opt/intel/openvino_2021.*/deployment_tools/demo/car.png -b 1
```

**_NOTE: You will see some long waiting or pinging messages. The model is running on the stick, you may just have to wait._**

Source: https://docs.openvino.ai/latest/openvino_inference_engine_tools_benchmark_tool_README.html

---

## 4. Run and Convert Your Own Model

To see an example of how to implement your own models, convert them for NCS2, and performing inference refer to [lenet.py](docker/lenet.py).

## 5. Copying to/from Docker Container

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
