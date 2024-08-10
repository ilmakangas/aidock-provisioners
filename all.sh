#!/bin/bash

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/comfyui/main/config/provisioning/default.sh

# Packages are installed after nodes so we can fix them...


APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/11cafe/comfyui-workspace-manager"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/GreenLandisaLie/AuraSR-ComfyUI"
    "https://github.com/kijai/ComfyUI-SUPIR"
    "https://github.com/kijai/ComfyUI-CCSR"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/TinyTerra/ComfyUI_tinyterraNodes"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/cubiq/ComfyUI_essentials"
)

declare -A CHECKPOINT_MODELS=(
    ["https://huggingface.co/StableDiffusionVN/Flux/resolve/main/Checkpoint/Flux_dev_v1.safetensors"]="Flux_dev_v1.safetensors"
    ["https://huggingface.co/RunDiffusion/Juggernaut-X-v10/resolve/main/Juggernaut-X-RunDiffusion-NSFW.safetensors"]="Juggernaut-X-RunDiffusion-NSFW.safetensors"
    ["https://huggingface.co/SG161222/RealVisXL_V4.0/resolve/main/RealVisXL_V4.0.safetensors"]="RealVisXL_V4.0.safetensors"
    ["https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0F_fp16.safetensors"]="SUPIR-v0F_fp16.safetensors"
    ["https://huggingface.co/Kijai/SUPIR_pruned/resolve/main/SUPIR-v0Q_fp16.safetensors"]="SUPIR-v0Q_fp16.safetensors"
    ["https://huggingface.co/Kijai/ccsr-safetensors/resolve/main/real-world_ccsr-fp32.safetensors"]="real-world_ccsr-fp32.safetensors"
    ["https://huggingface.co/SG161222/RealVisXL_V4.0_Lightning/resolve/main/RealVisXL_V4.0_Lightning.safetensors"]="RealVisXL_V4.0_Lightning.safetensors"
)

declare -A CLIP_MODELS=(
)

declare -A UNET_MODELS=(
)

declare -A VAE_MODELS=(
)

declare -A LORA_MODELS=(
    ["https://huggingface.co/comfyanonymous/flux_RealismLora_converted_comfyui/resolve/main/flux_realism_lora.safetensors"]="flux_realism_lora.safetensors"
    ["https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid_sdxl_lora.safetensors"]="ip-adapter-faceid_sdxl_lora.safetensors"
    ["https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid-plusv2_sdxl_lora.safetensors"]="ip-adapter-faceid-plusv2_sdxl_lora.safetensors"
    ["https://civitai.com/api/download/models/340833?type=Model&format=SafeTensor"]="skinrealism-reworked.safetensors"
)

declare -A ESRGAN_MODELS=(
    ["https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"]="RealESRGAN_x4.pth"
    ["https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"]="4x_NMKD-Siax_200k.pth"
)

declare -A CONTROLNET_MODELS=(
    ["https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models_XL/adapter-xl-canny.pth"]="adapter-xl-canny.pth"
    ["https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models_XL/adapter-xl-openpose.pth"]="adapter-xl-openpose.pth"
    ["https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models_XL/adapter-xl-sketch.pth"]="adapter-xl-sketch.pth"
)

declare -A AURASR_MODELS=(
    ["https://huggingface.co/fal/AuraSR/resolve/main/model.safetensors"]="model.safetensors"
    ["https://huggingface.co/fal/AuraSR/resolve/main/config.json"]="config.json"
)

declare -A IPADAPTER_MODELS=(
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors"]="ip-adapter_sdxl_vit-h.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors"]="ip-adapter-plus_sdxl_vit-h.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus-face_sdxl_vit-h.safetensors"]="ip-adapter-plus-face_sdxl_vit-h.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl.safetensors"]="ip-adapter_sdxl.safetensors"
    ["https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid_sdxl.bin"]="ip-adapter-faceid_sdxl.bin"
    ["https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid-plusv2_sdxl.bin"]="ip-adapter-faceid-plusv2_sdxl.bin"
    ["https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid-portrait_sdxl.bin"]="ip-adapter-faceid-portrait_sdxl.bin"
    ["https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid-portrait_sdxl_unnorm.bin"]="ip-adapter-faceid-portrait_sdxl_unnorm.bin"
)

declare -A CLIP_VISION_MODELS=(
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors"]="CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/image_encoder/model.safetensors"]="CLIP-ViT-bigG-14-laion2B-39B-b160k.safetensors"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

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
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/checkpoints" \
        CHECKPOINT_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/unet" \
        UNET_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/loras" \
        LORA_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/controlnet" \
        CONTROLNET_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/vae" \
        VAE_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/clip" \
        CLIP_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/esrgan" \
        ESRGAN_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/Aura-SR" \
        AURASR_MODELS
     provisioning_get_models \
        "${WORKSPACE}/modelstorage/ipadapter" \
        IPADAPTER_MODELS
    provisioning_get_models \
        "${WORKSPACE}/modelstorage/clip_vision" \
        CLIP_VISION_MODELS
    provisioning_copy_models
    provisioning_print_end
}

function pip_install() {
    if [[ -z $MAMBA_BASE ]]; then
            "$COMFYUI_VENV_PIP" install --no-cache-dir "$@"
        else
            micromamba run -n comfyui pip install --no-cache-dir "$@"
        fi
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip_install ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip_install -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip_install -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_default_workflow() {
    if [[ -n $DEFAULT_WORKFLOW ]]; then
        workflow_json=$(curl -s "$DEFAULT_WORKFLOW")
        if [[ -n $workflow_json ]]; then
            echo "export const defaultGraph = $workflow_json;" > /opt/ComfyUI/web/scripts/defaultGraph.js
        fi
    fi
}

function provisioning_get_models() {
    if [[ -z $2 ]]; then return 1; fi
    dir="$1"
    mkdir -p "$dir"
    shift
    local -n arr=$1

    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${!arr[@]}"; do
        fn="${arr[$url]}"
        if [ ! -f "${dir}/${fn}" ]; then
            printf "Downloading: %s as %s\n" "${url}" "${fn}"
        
            provisioning_download "${url}" "${dir}/${fn}"
            printf "\n"
        else
            printf "Model: %s already exists\n" "${dir}/${fn}"
        fi
       
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

function provisioning_copy_models() {
    printf "Copying models to local storage \n\n"
    mkdir -p /opt/ComfyUI/models
    rsync -ah --progress "/workspace/modelstorage/" "/opt/ComfyUI/models"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -O "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -O "$2" "$1"
    fi
}

provisioning_start