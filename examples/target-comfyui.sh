#!/bin/bash

# Uncomment the following line and replace the URL to point into your OWN repository
# wget "https://raw.githubusercontent.com/ilmakangas/aidock-provisioners/main/targets/comfyui/base.sh" -O base.sh || { echo "ERROR: Failed to load the base include"; exit 1; }
chmod +x base.sh
source base.sh

############### BASE ##############
# Point all the URLs into your own repository
provisioning_include "https://raw.githubusercontent.com/ilmakangas/aidock-provisioners/main/includes/comfyui/base/base-nodes.sh"
provisioning_include "https://raw.githubusercontent.com/ilmakangas/aidock-provisioners/main/includes/comfyui/base/flux-increased-perf.sh"

############### UPSCALE ###############
# Point all the URLs into your own repository
provisioning_include "https://raw.githubusercontent.com/ilmakangas/aidock-provisioners/main/includes/comfyui/upscaling/esrgan.sh"
provisioning_include "https://raw.githubusercontent.com/ilmakangas/aidock-provisioners/main/includes/comfyui/upscaling/aurasr.sh"


############## MODELS ##################


# APT_PACKAGES

# PIP_PACKAGES

# NODES

# CHECKPOINT_MODELS
CHECKPOINT_MODELS["https://huggingface.co/StableDiffusionVN/Flux/resolve/main/Checkpoint/Flux_dev_v1.safetensors"]="Flux_dev_v1.safetensors"

# CLIP_MODELS

# UNET_MODELS

# VAE_MODELS

# LORA_MODELS
LORA_MODELS["https://huggingface.co/comfyanonymous/flux_RealismLora_converted_comfyui/resolve/main/flux_realism_lora.safetensors"]="flux_realism_lora.safetensors"

# UPSCALE_MODELS

# CONTROLNET_MODELS

# AURASR_MODELS

# IPADAPTER_MODELS

# CLIP_VISION_MODELS

############ END MODELS ###########

function provisioning_start() {
    if [[ ! -d /opt/environments/python ]]; then 
        export MAMBA_BASE=true
    fi
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh comfyui


    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_default_workflow
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_models 
    provisioning_file_patches
    provisioning_print_end

}

provisioning_start