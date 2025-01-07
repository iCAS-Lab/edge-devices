# Synaptics Astra Machina

## Setup:

### Device Setup:

Setup instructions can be found here:

- https://synaptics-astra.github.io/doc/v/1.4.0/quickstart/hw_setup.html

### SD Card Boot:

Derived from instructions found here:

https://synaptics-astra.github.io/doc/v/1.4.0/linux/index.html#booting-from-spi-and-sd-cards

Additionally, here are some abbreviated instructions:

1. TODO

### Board Specs:

Board specifications (for SL1680 platform) can be found:

- https://synaptics-astra.github.io/doc/v/1.4.0/hw/sl1680.html

## ML Pipeline Documentation

The Synaptics board uses a custom-built API called SyNAP (Synaptics Neural Network Acceleration and Processing) for deploying ML workloads on their hardware.

Links to the documentation (3.1.0 at the time of writing) and SyNAP GitHub repository:

- https://synaptics-synap.github.io/doc/v/3.1.0/docs/manual/index.html#
- https://synaptics-synap.github.io/doc/v/latest/docs/manual/working_with_models.html#
- https://github.com/synaptics-synap

### ML Abbreviated Instructions:

1. Download the SyNAP Docker image:

```shell
docker pull ghcr.io/synaptics-synap/toolkit:3.1.0
```

2. Run the SyNAP command using the following docker command:

```shell
docker run -i --rm -u $(id -u):$(id -g) -v $HOME:$HOME -w $(pwd) ghcr.io/synaptics-synap/toolkit:3.1.0
```

**_TIP: Add the following line to your `.bashrc` or `.zshrc` config file to easily rerun the SyNAP executable easier in the future:_**

```shell
alias synap='docker run -i --rm -u $(id -u):$(id -g) -v $HOME:$HOME -w $(pwd) ghcr.io/synaptics-synap/toolkit:3.1.0
```

#### Convert a PyTorch Model

**_NOTE: SyNAP requires PyTorch models to be saved in TorchScript format to bundle to the network architecture and learned parameters together._**

0. Here we will use Ultralytics to convert YOLOv11n and profile it.

1. Download the YOLOv11n model using Ultralytics:

```shell
yolo export model=yolo11n format=torchscript imgsz=480,640
```

2. Use the `synap` docker alias mentioned above to run the SyNAP conversion:

```shell
synap convert --model yolo11n.torchscript --meta yolo11n.yaml --target SL1680 --out-dir out
```

```
Options used:
    --model: the model to convert
    --meta: the meta-data file to use with the model (see the example yolo11n.yaml file included)
    --target: the Synaptics board to target (i.e. SL1680)
    --out-dir: the directory where the converted model is placed
```

3. Inside the `out` directory you should find a `model.synap` file. Transfer this to the Synaptics SL1680 board.

4. Once transferred and logged into the `SL1680` board, change to the directory with the `model.synap` file and then run the following command to benchmark (i.e. profile) the model:

```shell
synap_cli -m model.synap -r 10 random
```

This runs the model on 10 random inputs and the following output should be provided:

```
Flush/invalidate: yes
Loop period (ms): 0
Network inputs: 1
Network outputs: 1
Input buffer: input size: 1843200 : random
Output buffer: attach_Concat_/23/Concat_5/out0 size: 1058400

Predict #0: 1044.34 ms
...

Inference timings (ms):  load: 51.05  init: 11.10  min: 1042.88  median: 1044.14  max: 1046.35  stddev: 1.13  mean: 1044.58
```

##### Troubleshooting

You may get a message saying the following:

```
E:SyNAP: load_model():51:Failed to prepare network
E:SyNAP: load_model_data():177: Failed to load model
...
```

Solution: Attempt to re-run the network. This is most-likely an IO reservation problem.
