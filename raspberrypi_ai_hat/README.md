# YOLO to Hailo HEF Deployment on Raspberry Pi 5

## Introduction
This project focuses on converting an **Ultralytics YOLO** model into **Hailo HEF format** using **Hailo AI Suite**, then deploying and evaluating performance on a **Raspberry Pi 5 with Hailo8 AI Hat**. The final outcome will be documented in this README, along with the necessary scripts and instructions to replicate the process.

## Phase 1: Environment Setup

- Set up **Hailo AI Suite** for model conversion.
- Install **Ultralytics YOLO** in a containerized environment.
- Configure **Raspberry Pi 5** with dependencies and Hailo8 AI Hat.

### Steps:
1. **Install the Hailo AI Suite** using this link:  
🔗 [Hailo AI Suite Installation](https://hailo.ai/developer-zone/documentation/hailo-sw-suite-2025-04/?sp_referrer=suite/suite_install.html#docker-installation)

   
2. **Install the Ultralytics YOLO Docker container** _(Note: you must log in to Docker Hub to pull the image)_:
   - Pull the container:
     ```bash
     docker pull ultralytics/ultralytics
     ```

   - Create the following folder hierarchy:
     ```
     /home/ultralytics/
              ├── ultralytics_share/
     ```
   - Create a script `run_ultralytics_docker.sh` _(optional)_ for easier execution:
     - **Saved inside** `/home/ultralytics/`
     - Contains the following text:
       ```bash
       #!/bin/bash
       docker run --gpus all -it --rm \
         -v /home/ultralytics/ultralytics_share:/workspace \
         ultralytics/ultralytics
       ```
     - To make the script executable:
       ```bash
       chmod +x ~/run_ultralytics_docker.sh
       ```
     - To run it anytime:
       ```bash
       ./run_ultralytics_docker.sh
       ```

   - **Verification: Confirm Installation Success**  
     After installing **Ultralytics YOLO**, run the following command to verify that YOLOv8 is installed and working:
     ```bash
     yolo task=detect mode=predict model=yolov8n.pt source=https://ultralytics.com/images/bus.jpg
     ```
     Expected output:
     - The YOLO model should load successfully.
     - Object detection results should appear.
     - The processed image will be saved with bounding boxes.
     - Results will be stored in the ```/ultralytics/runs/detect/predict``` folder in the docker container.

3. **Prepare Raspberry Pi 5 & AI Hat**  
   Follow the official **Raspberry Pi documentation** for installation and setup:  
   - 🔗 [AI Hat+ - Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/accessories/ai-hat-plus.html)  
   - 🔗 [Raspberry Pi AI Overview](https://www.raspberrypi.com/documentation/computers/ai.html)  

   **Key setup steps (Refer to the Documentation):**
   - Install the necessary **drivers** for AI Hat+.
   - Configure **hardware connections** to Raspberry Pi 5.
   - Test an **example inference** using the Hailo runtime.


