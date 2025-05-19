# YOLO to Hailo HEF Deployment on Raspberry Pi 5

## Introduction
This project focuses on converting an **Ultralytics YOLO** model into **Hailo HEF format** using **Hailo AI Suite**, then deploying and evaluating performance on a **Raspberry Pi 5 with Hailo8 AI Hat**. The final outcome will be documented in this README, along with the necessary scripts and instructions to replicate the process.

## Phase 1: Environment Setup

- Set up **Hailo AI Suite** for model conversion.
- Install **Ultralytics** 

### Step 1. **Install the Hailo AI Suite** using this link:  
🔗 [Hailo AI Suite Installation](https://hailo.ai/developer-zone/documentation/hailo-sw-suite-2025-04/?sp_referrer=suite/suite_install.html#docker-installation)

   
### Step 2. Ultalytics Installation (2 options)

#### Option 1:

**Install the Ultralytics YOLO Docker container** _(Note: you must log in to Docker Hub to pull the image)_:
   - Pull the container:
     ```bash
     #!/bin/bash
     docker pull ultralytics/ultralytics
     ```

   - Create the following folder hierarchy:
     ```
     /home/ultralytics/
              ├── ultralytics_share/
     ```
   - Create a script `run_ultralytics_docker.sh` _(optional)_ for easier execution:
     - **Saved inside** `/home/ultralytics/`
     - Containing the following text:
       ```bash
       #!/bin/bash
       docker run --gpus all -it --rm \
         -v /home/ultralytics/ultralytics_share:/workspace \
         ultralytics/ultralytics
       ```
     - To make the script executable:
       ```bash
       #!/bin/bash
       chmod +x ~/run_ultralytics_docker.sh
       ```
     - To run it anytime:
       ```bash
       #!/bin/bash
       ./run_ultralytics_docker.sh
       ```

      - **Verification: Confirm Installation Success**  
        After installing **Ultralytics YOLO**, run the following command to verify that YOLOv8 is installed and working:
        ```bash
        #!/bin/bash
        yolo task=detect mode=predict model=yolov8n.pt source=https://ultralytics.com/images/bus.jpg
        ```
     Expected output:
     - The YOLO model should load successfully.
     - Object detection results should appear.
     - The processed image will be saved with bounding boxes.
     - Results will be stored in the ```/ultralytics/runs/detect/predict``` folder in the docker container.

#### Option 2:

**Use Python library to import Ultralytics and write a script for the model**

- **Install the ultralytics library**

    ```bash
    #!/bin/bash
    pip install ultralytics
    ```

- **Execute the test script to verify installation**

  ```python
  from ultralytics import YOLO

  # Load the YOLOv8 model
  model = YOLO("yolov8n.pt")

  # Run prediction on an image
  results = model.predict(source="https://ultralytics.com/images/bus.jpg", task="detect", mode="predict", save=True)

  # Display results
  print(results)
  ```
  Expected output:
     - The YOLO model should load successfully.
     - Object detection results should appear.
     - The processed image will be saved with bounding boxes.
     - Results will be stored in the ```/pythonfiledirectory/runs/detect/predict``` folder in the docker container.

## Phase 2: Model Conversion (YOLO to HEF)

- Export **YOLO model** to **ONNX** format.  
- Convert **ONNX model** to **HEF** using **Hailo AI Suite**.  
- Validate converted **HEF model** compatibility with Raspberry Pi 5.  


### Step 1. **Use Ultralytics to export model to ONNX format (2 options)**

***Option 1 - Ultralytics container***

- Run the following command to start the container:
  ```bash
  #!/bin/bash
  ./home/ultralytics/run_ultralytics_docker.sh
  ```

- Once inside the **Ultralytics Docker container**, run the following command to convert YOLOv8 to ONNX format:

  ```bash
  #!/bin/bash
  yolo export model=yolov8n.pt format=onnx
  ```
  The converted model should be added to the ```ultralytics ``` folder. You can now move the yolo8n.onnx file to the ```ultralytics_share``` folder.

***Option 2 - Python package example***

- The below script illustrates how to pull and train a model with a pre-structured dataset from Ultralytics. Use this example script to convert model to ONNX format

  ```python
  from ultralytics import YOLO
  import onnx

  # Load pretrained model
  model = YOLO("yolov8n.pt") #pick your model

  model.predict

  # Train the model on HomeObjects-3K dataset (insert your dataset here)
  model.train(data="HomeObjects-3K.yaml", epochs=5, imgsz=640,device='cuda')

  model = YOLO('runs/detect/train/weights/best.pt') #this is your best model from training

  model.export(format="onnx", device="cuda", imgsz=640, opset=13, simplify=True, dynamic=False, batch=1)
  ```
   
- The below example shows how to load a previously trained/finetuned model from a file and export.

  ```python
  from ultralytics import YOLO
  import onnx

  # Load pretrained model
  model = YOLO("path/to/your/model") #pick your model

  #perform the export
  model.export(format="onnx", device="cuda", imgsz=640, opset=13, simplify=True, dynamic=False, batch=1)
  ```
- When the export completes successfully, there will be a matching ```onnx``` model in the same directory as the model you exported. For example the top example code would place a file called ```best.onnx``` in the ```runs/detect/train/weights/``` folder.



# ***************** DRAFT BELOW *************
### Step 2. **Export ONNX model to HEF**  
- Open the Hailo AI Suite docker
- Copy your onnx model and a sample of 300 images from your dataset (these will be used by hailomz compile to optimize the model) to the shared_with_docker folder associated with your docker container
- run the hailomz compile command with all the options.....
-move the hef file from ..... to the shared_with_docker folder



# Phase 3 Execute Model on Pi and AI hat

### Step 3. **Prepare Raspberry Pi 5 & AI Hat**  
   Follow the official **Raspberry Pi documentation** for installation and setup:  
   - 🔗 [AI Hat+ - Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/accessories/ai-hat-plus.html)  
   - 🔗 [Raspberry Pi AI Overview](https://www.raspberrypi.com/documentation/computers/ai.html)  

   **Key setup steps (Refer to the Documentation):**
   - Install the necessary **drivers** for AI Hat+.
   - Configure **hardware connections** to Raspberry Pi 5.
   - Test an **example inference** using the Hailo runtime.




