FROM kubevirt/container-disk-v1alpha:v0.13.7

LABEL maintainer="Juan Manuel Torres <juanmanuel.torres@aventurabinaria.es>"

ARG OS_NAME="example_os"
ARG OS_VERSION="0.0"
ARG IMAGE_URL="https://example.com/os_xxx.img"
ARG FILE_NAME="os_xxx.img"
ARG IMAGE_NAME="os_xxx"
ARG IMAGE_EXTENSION="img"

ADD custom /mnt/custom
RUN echo "Download: $IMAGE_URL FILE: $FILE_NAME"; \
	set -x \
	&& yum update --releasever 28 -y \
	&& yum install -y findutils --releasever 28

RUN curl -kfSL $IMAGE_URL -o /disk/$FILE_NAME ; if [ $? != 0 ]; then exit 1; fi 

RUN KEY_LOOP="true"; \
while [ $KEY_LOOP == "true" ]; do \
	echo "Process extension: $IMAGE_EXTENSION"; \
	if [ "$IMAGE_EXTENSION" == "qcow2" ] ; then \
		qemu-img convert -f qcow2 -O raw /disk/$FILE_NAME /disk/$OS_NAME.img; \
		rm -rf /disk/$FILE_NAME; \
		KEY_LOOP="false"; \
	elif [ "$IMAGE_EXTENSION" == "vmdk" ] ; then \
		qemu-img convert -f vmdk -O raw /disk/$FILE_NAME /disk/$OS_NAME.img; \
		rm -rf /disk/$FILE_NAME; \
		KEY_LOOP="false"; \
	elif [ "$IMAGE_EXTENSION" == "bz2" ] ; then \
		bunzip2 /disk/$FILE_NAME; \
		rm -rf /disk/$FILE_NAME; \
		export FILE_NAME=$(ls -l /disk | grep "^-" | awk '{ print $9 }' | grep -v "$FILE_NAME"); \
		echo "New file name: $FILE_NAME"; \
		export IMAGE_EXTENSION=$(echo $FILE_NAME | cut -d"." -f2); \
	elif [ "$IMAGE_EXTENSION" == "img" ] ; then \
		if [ ! -f /disk/$OS_NAME.img ]; then \
			mv /disk/$FILE_NAME /disk/$OS_NAME.img; \
			ls /disk/; \
		fi ;\
		KEY_LOOP="false"; \
	else \
		KEY_LOOP="false"; \
	fi \
done
# 	&& yum install -y cloud-utils genisoimage \
#	&& cloud-localds /disk/$FILE_NAME /mnt/custom/user-data
