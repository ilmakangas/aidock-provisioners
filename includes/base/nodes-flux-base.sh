#!/bin/bash

# Increased CFG>1 speed for Flux
NODES+=("https://github.com/asagi4/ComfyUI-Adaptive-Guidance")
NODES+=("https://github.com/mcmonkeyprojects/sd-dynamic-thresholding")
FILE_PATCHES["https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/patches/dynthres_comfyui.py"]="/opt/ComfyUI/custom_nodes/sd-dynamic-thresholding/dynthres_comfyui.py"