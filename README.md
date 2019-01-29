# Kubevirt Images Generator

## Debian

- debian-container-disk:9.0
- debian-container-disk:8.0
- debian-container-disk:testing

## Ubuntu

- ubuntu-container-disk:18.0
- ubuntu-container-disk:16.0
- ubuntu-container-disk:14.0

## OpenSUSE

- opensuse-container-disk:15.0

## CentOS

- centos-container-disk:7.0

## Example Kubevirt

Create VM:

```
cat <<EOF | kubectl apply -f -
apiVersion: kubevirt.io/v1alpha2
kind: VirtualMachine
metadata:
  name: debian9
spec:
  running: false
  template:
    metadata:
      labels: 
        kubevirt.io/size: small
        kubevirt.io/domain: debian9
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
virtctl start debian9

virtctl console debian9
```

## Example in docker

Example: `docker pull tedezed/debian-container-disk:8.0`