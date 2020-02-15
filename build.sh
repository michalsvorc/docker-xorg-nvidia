#!/bin/bash
# Author: Michal Svorc <michal@svorc.sk>
# Build Docker image

# Utilities
get_nvidia_driver_version() {
    local version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
    printf "%s" ${version}
}

# Base variables
image_name='xorg-nvidia'
distribution='ubuntu'
distribution_version='18.04'

# Build variables
nvidia_driver_version=$(get_nvidia_driver_version)
image_tag="${distribution}-${distribution_version}"
image_tag_build="${image_tag}-${nvidia_driver_version}"

# Build
printf "Nvidia driver version: %s\n" ${nvidia_driver_version}

docker build \
    --tag "${image_name}:${image_tag_build}" \
    --build-arg distribution=${distribution} \
    --build-arg distribution_version=${distribution_version} \
    --build-arg nvidia_driver_version=${nvidia_driver_version} \
    .

# Tag finished build
docker tag "${image_name}:${image_tag_build}" "${image_name}:${image_tag}"