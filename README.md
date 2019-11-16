# Xorg with proprietary Nvidia driver Docker image

## About
Docker image with [Xorg](https://wiki.archlinux.org/index.php/Xorg) and proprietary [Nvidia driver](https://wiki.archlinux.org/index.php/NVIDIA) for running GUI applications with Nvidia GPU support.

## Video
Host system must have proprietary Nvidia driver installed. Driver version is detected at build time with `nvidia-smi` command.

## Audio
[ALSA](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture) audio support by default.

## Build
Select git branch with distribution tag and run `build.sh` helper script.

## Usage with another Dockerfile
Example sourcing `xorg-nvidia` as base image in Docker image with GUI application:
```Dockerfile
FROM xorg-nvidia:${<distribution_tag>}

# Build-time variables
ARG user_name
ARG groupid_audio

# Non-system user setup
RUN useradd -ms /bin/bash ${user_name} \
    && groupadd -g ${groupid_audio} audio_host \
    && usermod -aG audio_host ${user_name} \
    && usermod -aG audio ${user_name} \
    && usermod -aG video ${user_name}

...

ENTRYPOINT ["<GUI-application>"]
```

User running processes in Docker container should belong to `video`, `audio` groups. 

### Audio host group
`audio_host` is an  additional group which should have group id identical to host `audio` group id to have correct permissions for reading host audio resources. You can get it on host machine with `groupid_audio=$(cut -d: -f3 < <(getent group audio))` command. You can skip this if you don't intend using audio with your GUI application.

### Docker run
```Dockerfile
docker run \
    -it \
    --rm \
    --device /dev/snd \
    --device /dev/dri \
    --device /dev/nvidia-modeset \
    --device /dev/nvidiactl \
    --device /dev/nvidia0 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --env DISPLAY=$DISPLAY \
    ${<gui_application_image>}
```

### Xhost
[Xhost](https://wiki.archlinux.org/index.php/Xhost) might be required to grant Docker process the rights to access the X-Server. To allow these rights at container startup and then deny them as container stops, you can execute `docker run` command with xhost:

```bash
xhost +local:docker \
&& docker run \
    --rm \
    ...
; xhost -local:docker
```
