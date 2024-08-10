#!/bin/bash

APT_PACKAGES=(
)

PIP_PACKAGES=(
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/11cafe/comfyui-workspace-manager"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/GreenLandisaLie/AuraSR-ComfyUI"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/TinyTerra/ComfyUI_tinyterraNodes"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/chrisgoringe/cg-use-everywhere"
)

declare -A CHECKPOINT_MODELS=(
)

declare -A CLIP_MODELS=(
)

declare -A UNET_MODELS=(
)

declare -A VAE_MODELS=(
)

declare -A LORA_MODELS=(
)

declare -A UPSCALE_MODELS=(
)

declare -A CONTROLNET_MODELS=(
)

declare -A AURASR_MODELS=(
)

declare -A IPADAPTER_MODELS=(
)

declare -A CLIP_VISION_MODELS=(
)


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

function provisioning_include() {
    if [[ -z $1 ]]; then return 1; fi
    url="$1"
   
    printf "Including: %s\n" "$url"
    wget -O include.sh "$url"

    if [[ $url == *"secret"* ]]; then
        echo "Decrypting SOPS include"
        ./sops decrypt --in-place include.sh || { echo "ERROR: Failed to decrypt the include"; exit 1; }
    fi
    chmod +x include.sh    
    source include.sh
    rm include.sh
}

function provisioning_models() {
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/checkpoints" \
        "/opt/ComfyUI/models/checkpoints" \
        CHECKPOINT_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/unet" \
        "/opt/ComfyUI/models/unet" \
        UNET_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/loras" \
        "/opt/ComfyUI/models/loras" \
        LORA_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/controlnet" \
        "/opt/ComfyUI/models/controlnet" \
        CONTROLNET_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/vae" \
        "/opt/ComfyUI/models/vae" \
        VAE_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/clip" \
        "/opt/ComfyUI/models/clip" \
        CLIP_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/esrgan" \
        "/opt/ComfyUI/models/upscale_models" \
        UPSCALE_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/Aura-SR" \
        "/opt/ComfyUI/models/Aura-SR" \
        AURASR_MODELS
     provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/ipadapter" \
        "/opt/ComfyUI/models/ipadapter" \
        IPADAPTER_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/clip_vision" \
        "/opt/ComfyUI/models/clip_vision" \
        CLIP_VISION_MODELS
}

function provisioning_ensure_models() {
    if [[ -z $2 ]]; then return 1; fi
    storagedir="$1"
    mkdir -p "$storagedir"
    shift
    localdir="$1"
    mkdir -p "$localdir"
    shift
    local -n arr=$1

    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$storagedir"
    for url in "${!arr[@]}"; do
        fn="${arr[$url]}"
        if [ ! -f "${storagedir}/${fn}" ]; then
            printf "Downloading: %s as %s\n" "${url}" "${fn}"
        
            provisioning_download "${url}" "${storagedir}/${fn}"
            printf "\n"
        else
            printf "Model: %s already downloaded\n" "${storagedir}/${fn}"
        fi
        printf "Copying %s to local storage\n" "${fn}"
        rsync -ah --progress "${storagedir}/${fn}" "${localdir}"
    done
}

function provisioning_patch_file() {
    if [[ -z $2 ]]; then return 1; fi
    url="$1"
    shift
    localfile="$1"
    localdir=$(dirname "$1")
    mkdir -p "$localdir"

    printf "Patching %s with file from: %s\n" "$localfile" "$url"
    wget -O "$localfile" "$url"
}



function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
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