#!/usr/bin/env bash
# Author: Michal Svorc <michalsvorc.com>
# Build Docker image

set -o errexit      # abort on nonzero exitstatus
set -o nounset      # abort on unbound variable
set -o pipefail     # don't hide errors within pipes
# set -o xtrace       # debugging

# Utilities
_get_nvidia_driver_version() {
    local version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
    printf "%s" "${version}"
}

_print_nvidia_driver_version() {
    local version="${1}"
    printf "Nvidia driver version: %s\n" "${version}"
}

# Parent image arguments
parent_image_name='ubuntu'
parent_image_tag='20.04'

# Build arguments
image_name='michalsvorc/xorg-nvidia'
image_tag="${parent_image_name}-${parent_image_tag}"
nvidia_driver_version=$(_get_nvidia_driver_version)
image_tag_build="${image_tag}-${nvidia_driver_version}"

# Print Nvidia driver version
_print_nvidia_driver_version "${nvidia_driver_version}"

# Build and re-tag finished build
docker build \
    --no-cache \
    --tag "${image_name}:${image_tag_build}" \
    --build-arg parent_image_name="${parent_image_name}" \
    --build-arg parent_image_tag="${parent_image_tag}" \
    --build-arg nvidia_driver_version="${nvidia_driver_version}" \
    . \
    && docker tag "${image_name}:${image_tag_build}" "${image_name}:${image_tag}"
