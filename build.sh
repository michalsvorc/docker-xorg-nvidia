#!/bin/bash
# Author: Michal Svorc <michalsvorc.com>
# Build Docker image

# Utilities
get_nvidia_driver_version() {
    local version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
    printf "%s" ${version}
}

# Base variables
image_name='michalsvorc/xorg-nvidia'
base_image='ubuntu'
base_image_tag='18.04'

# Build variables
nvidia_driver_version=$(get_nvidia_driver_version)
image_tag="${base_image}-${base_image_tag}"
image_tag_build="${image_tag}-${nvidia_driver_version}"

# Print Nvidia driver version
printf "Nvidia driver version: %s\n" ${nvidia_driver_version}

# Build and tag finished build
docker build \
    --no-cache \
    --tag "${image_name}:${image_tag_build}" \
    --build-arg base_image=${base_image} \
    --build-arg base_image_tag=${base_image_tag} \
    --build-arg nvidia_driver_version=${nvidia_driver_version} \
    . \
    && docker tag "${image_name}:${image_tag_build}" "${image_name}:${image_tag}"
