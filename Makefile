build:
	/bin/bash generator

build-old-builder:
	cd old-builder && docker build -f Dockerfile -t tedezed/kubevirt-container-disk:old .