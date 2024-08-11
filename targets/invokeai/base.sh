#!/bin/bash

APT_PACKAGES=(
)

PIP_PACKAGES=(
)

NODES=(
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

declare -A FILE_PATCHES=(
)



function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
        $INVOKEAI_VENV_PIP install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${EXTENSIONS[@]}"; do
        dir="${repo##*/}"
        path="/opt/invokeai/nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating extension: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                    $INVOKEAI_VENV_PIP install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                $INVOKEAI_VENV_PIP install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
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
        "/workspace/models/checkpoints" \
        CHECKPOINT_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/unet" \
        "/workspace/models/unet" \
        UNET_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/loras" \
        "/workspace/models/loras" \
        LORA_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/controlnet" \
        "/workspace/models/controlnet" \
        CONTROLNET_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/vae" \
        "/workspace/models/vae" \
        VAE_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/clip" \
        "/workspace/models/clip" \
        CLIP_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/esrgan" \
        "/workspace/models/upscale_models" \
        UPSCALE_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/Aura-SR" \
        "/workspace/models/Aura-SR" \
        AURASR_MODELS
     provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/ipadapter" \
        "/workspace/models/ipadapter" \
        IPADAPTER_MODELS
    provisioning_ensure_models \
        "${WORKSPACE}/modelstorage/clip_vision" \
        "/workspace/models/clip_vision" \
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

function provisioning_file_patches() {
    for url in "${!FILE_PATCHES[@]}"; do
        fn="${FILE_PATCHES[$url]}"
        provisioning_patch_file "$url" "$fn"
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