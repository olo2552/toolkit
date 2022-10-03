ARCH = amd64

UID = $(id -u ${USER})
GID = $(id -g ${USER})
IMAGE_TAG = "toolkit-${UID}-${GID}-${ARCH}"

build:
	docker build -t $(IMAGE_TAG) \
		--build-arg USER_ID=${UID} \
		--build-arg GROUP_ID=$(GID) \
		--build-arg ARCH=$(ARCH) \
		.

run:
	docker run -it ${IMAGE_TAG}
