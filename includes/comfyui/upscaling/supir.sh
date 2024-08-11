#!/bin/bash

NODES+=("https://github.com/kijai/ComfyUI-SUPIR")

CHECKPOINT_MODELS["https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0F_fp16.safetensors"]="SUPIR-v0F_fp16.safetensors"
CHECKPOINT_MODELS["https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0Q_fp16.safetensors"]="SUPIR-v0Q_fp16.safetensors"
CHECKPOINT_MODELS["https://huggingface.co/SG161222/RealVisXL_V4.0_Lightning/resolve/main/RealVisXL_V4.0_Lightning.safetensors"]="RealVisXL_V4.0_Lightning.safetensors"
