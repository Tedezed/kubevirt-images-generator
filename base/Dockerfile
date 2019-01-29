FROM kubevirt/container-disk-v1alpha

LABEL maintainer="Juan Manuel Torres <juanmanuel.torres@aventurabinaria.es>"

ARG OS_NAME="example_os"
ARG OS_VERSION="0.0"
ARG IMAGE_URL="https://example.com/os_xxx.img"
ARG FILE_NAME="os_xxx.img"
ARG IMAGE_NAME="os_xxx"
ARG IMAGE_EXTENSION="img"

ADD custom /mnt/custom
RUN echo "Download: $IMAGE_URL FILE: $FILE_NAME" \
	&& curl -SL $IMAGE_URL -o /disk/$FILE_NAME

RUN echo $IMAGE_EXTENSION && \
	if [ "$IMAGE_EXTENSION" == "qcow2" ] ; then \
		qemu-img convert -f qcow2 -O raw /disk/$FILE_NAME /disk/$OS_NAME.img; \
		rm -rf /disk/$FILE_NAME; \
	elif [ "$IMAGE_EXTENSION" == "vmdk" ] ; then \
		qemu-img convert -f vmdk -O raw /disk/$FILE_NAME /disk/$OS_NAME.img; \
		rm -rf /disk/$FILE_NAME; \
	fi
# 	&& yum install -y cloud-utils genisoimage \
#	&& cloud-localds /disk/$FILE_NAME /mnt/custom/user-data