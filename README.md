# Kubevirt Images Generator

### Debian

- [debian-container-disk:10.0](https://hub.docker.com/r/tedezed/debian-container-disk/tags)
- [debian-container-disk:9.0](https://hub.docker.com/r/tedezed/debian-container-disk)
- [debian-container-disk:8.0](https://hub.docker.com/r/tedezed/debian-container-disk)
- [debian-container-disk:testing](https://hub.docker.com/r/tedezed/debian-container-disk)

### Ubuntu

- [ubuntu-container-disk:18.0](https://hub.docker.com/r/tedezed/ubuntu-container-disk)
- [ubuntu-container-disk:16.0](https://hub.docker.com/r/tedezed/ubuntu-container-disk)
- [ubuntu-container-disk:14.0](https://hub.docker.com/r/tedezed/ubuntu-container-disk)

### CentOS

- [centos-container-disk:7.0](https://hub.docker.com/r/tedezed/centos-container-disk)

### Fedora

- [fedora-container-disk:29](https://hub.docker.com/r/tedezed/fedora-container-disk)
- [fedora-container-disk:28](https://hub.docker.com/r/tedezed/fedora-container-disk)
- [fedora-container-disk:27](https://hub.docker.com/r/tedezed/fedora-container-disk)

### OpenSUSE

- [opensuse-container-disk:15.0](https://hub.docker.com/r/tedezed/opensuse-container-disk)

### CirrOS

- [cirros-container-disk:0.4.0](https://hub.docker.com/r/tedezed/cirros-container-disk)

### CoreOS

- [coreos-container-disk:1967.4.0](https://hub.docker.com/r/tedezed/coreos-container-disk)

## Examples Kubevirt

Create VM (kubevirt.io/v1alpha3, Debian 9):

```
cat <<EOF | kubectl apply -f -
apiVersion: kubevirt.io/v1alpha3
kind: VirtualMachine
metadata:
  name: debian
spec:
  running: false
  template:
    metadata:
      labels: 
        kubevirt.io/size: small
        kubevirt.io/domain: debian
    spec:
      domain:
        cpu:
          cores: 2
        devices:
          disks:
            - name: containervolume
              disk:
                bus: virtio
            - name: cloudinitvolume
              disk:
                bus: virtio
          interfaces:
          - name: default
            bridge: {}
        resources:
          requests:
            memory: 1024M
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containervolume
          containerDisk:
            image: tedezed/debian-container-disk:9.0
        - name: cloudinitvolume
          cloudInitNoCloud:
            userData: |-
              #cloud-config
              chpasswd:
                list: |
                  debian:debian
                  root:toor
                expire: False
EOF
```

Create VM old (kubevirt.io/v1alpha2, Debian 9):

```
cat <<EOF | kubectl apply -f -
apiVersion: kubevirt.io/v1alpha2
kind: VirtualMachine
metadata:
  name: debian
spec:
  running: false
  template:
    metadata:
      labels: 
        kubevirt.io/size: small
        kubevirt.io/domain: debian
    spec:
      domain:
        cpu:
          cores: 2
        devices:
          disks:
            - name: containerdisk
              volumeName: containervolume
              disk:
                bus: virtio
            - name: cloudinitdisk
              volumeName: cloudinitvolume
              disk:
                bus: virtio
          interfaces:
          - name: default
            bridge: {}
        resources:
          requests:
            memory: 1024M
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containervolume
          containerDisk:
            image: tedezed/debian-container-disk:9.0
        - name: cloudinitvolume
          cloudInitNoCloud:
            userData: |-
              #cloud-config
              chpasswd:
                list: |
                  debian:debian
                  root:toor
                expire: False
EOF
```

Conect to vm:
```
kubectl get vms
virtctl start debian

virtctl console debian
```

### Create VM with Debian 10

Currently Debian 10 has problems to start with cloud-init, you can use the following example to use it and solve the problem temporarily.

```
cat <<EOF | kubectl apply -f -
apiVersion: kubevirt.io/v1alpha3
kind: VirtualMachine
metadata:
  name: debian
spec:
  running: false
  template:
    metadata:
      labels: 
        kubevirt.io/size: small
        kubevirt.io/domain: debian
    spec:
      domain:
        cpu:
          cores: 2
        devices:
          disks:
            - name: containervolume
              disk:
                bus: virtio
            - name: cloudinitvolume
              disk:
                bus: virtio
          interfaces:
          - name: default
            bridge: {}
        resources:
          requests:
            memory: 1024M
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containervolume
          containerDisk:
            image: tedezed/debian-container-disk:10.0
        - name: cloudinitvolume
          cloudInitNoCloud:
            userData: |-
              #cloud-config
              bootcmd:
                - echo cloud-init=disabled > /etc/cloud/cloud-init.disabled
                - [ /bin/bash, -c, 'echo -e "demopass\ndemopass" | passwd root' ]
                - reboot
EOF
```

## Example in docker

Example: `docker pull tedezed/debian-container-disk:8.0`

## Customizable use

Edit the file build_variable with your OS images, personal Docker registry and execute the next command to compile:
```
source build_variable
make build
```
