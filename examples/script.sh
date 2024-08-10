#!/bin/bash

wget "https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/base.include.sh" -O base.sh || { echo "ERROR: Failed to load the base include"; exit 1; }
chmod +x base.sh
source base.sh

############### BASE ##############
provisioning_include "https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/includes/base/nodes-base.sh"
provisioning_include "https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/includes/base/nodes-flux-base.sh"

############### UPSCALE ###############
provisioning_include "https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/includes/upscaling/esrgan.sh"
provisioning_include "https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/includes/upscaling/aurasr.sh"


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
provisioning_include "https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/includes/upscaling/esrgan.sh"

# CONTROLNET_MODELS

# AURASR_MODELS
provisioning_include "https://raw.githubusercontent.com/ilmakangas/comfyui-provisioners/main/includes/upscaling/aurasr.sh"

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