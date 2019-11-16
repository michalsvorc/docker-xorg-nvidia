#!/bin/bash
# Author: Michal Svorc <michal@svorc.sk>
# Build Docker image

# Declare variables
image_name='xorg-nvidia'
distribution=ubuntu
distribution_tag=18.04
nvidia_driver_version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)

# Build
docker build \
    --tag "${image_name}:${distribution_tag}-${distribution}" \
    --build-arg distribution=${distribution} \
    --build-arg distribution_tag=${distribution_tag} \
    --build-arg nvidia_driver_version=${nvidia_driver_version} \
    .
