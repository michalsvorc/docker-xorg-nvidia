ARG distribution
ARG distribution_tag

FROM ${distribution}:${distribution_tag}

ARG nvidia_driver_version
ARG nvidia_driver_installer=nvidia_installer.run

# Install packages
RUN apt-get update \
    && apt-get install -y \
    alsa \
    alsa-utils \
    wget \
    libsdl2-mixer-2.0-0 \
    libsdl2-image-2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Nvidia driver
RUN wget \
    # Download driver
    -c http://us.download.nvidia.com/XFree86/Linux-x86_64/${nvidia_driver_version}/NVIDIA-Linux-x86_64-${nvidia_driver_version}.run \
    -O /tmp/${nvidia_driver_installer} \
    --no-verbose \
    --show-progress \
    --progress=bar:force \
    # Install driver
    && sh /tmp/${nvidia_driver_installer} \
    --accept-license \
    --silent \
    --no-backup \
    --no-kernel-module \
    --no-nouveau-check \
    --no-check-for-alternate-installs \
    --install-libglvnd \
    && rm /tmp/${nvidia_driver_installer}