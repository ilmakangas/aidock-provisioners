#!/bin/bash

if [[ -z $LOADER_TARGET ]]; then
        echo "ERROR: LOADER_TARGET not set"
        exit 1
fi

if [[ -z $LOADER_SOPSKEY ]]; then
        echo "ERROR: LOADER_SOPSKEY not set"
        exit 1
fi

echo "${LOADER_SOPSKEY}" > sops.key

wget "${LOADER_TARGET}" -O target.sh || { echo "ERROR: Failed to load the target"; exit 1; }

wget https://github.com/getsops/sops/releases/download/v3.9.0/sops-v3.9.0.linux.amd64 -O sops || { echo "ERROR: Failed to load SOPS binary"; exit 1; }
chmod +x sops

echo "Decrypting target"
SOPS_AGE_KEY_FILE=sops.key ./sops decrypt --in-place target.sh || { echo "ERROR: Failed to decrypt the target"; exit 1; }
rm sops.key
rm sops

echo "Executing target"
source target.sh