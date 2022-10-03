#!/bin/bash
ARCH=amd64
GID=$(id -g ${USER})
IMAGE_TAG="toolkit-${UID}-${GID}-${ARCH}"
docker build -t ${IMAGE_TAG} \
    --build-arg USER_ID=${UID} \
    --build-arg GROUP_ID=${GID} \
    --build-arg ARCH=${ARCH} \
    .