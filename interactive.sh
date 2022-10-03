#!/bin/bash
ARCH=amd64
GID=$(id -g ${USER})
IMAGE_TAG="toolkit-${UID}-${GID}-${ARCH}"
docker run -it ${IMAGE_TAG}