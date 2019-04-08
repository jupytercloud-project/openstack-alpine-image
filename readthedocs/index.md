- https://docs.openstack.org/image-guide/
- https://docs.openstack.org/image-guide/openstack-images.html#disk-partitions-and-resize-root-partition-on-boot-cloud-init

## Build Host
### Qemu
```bash
$ brew install qemu
```

### Packer
- https://www.packer.io/

#### Installation
```bash
$ brew install packer
```

### Openstack
cf https://docs.openstack.org/python-openstackclient/rocky/
```bash
$ brew install python2
$ pip2 install python-openstackclient
```
## Built Image
### Parted

### Partition table
#### GPT

### Logical Volume Manager

### File System
#### XFS

### Boot Loader
#### GRUB

### Cloud Instance Customization
#### cloud-init
- [Cloud Init](https://cloudinit.readthedocs.io/en/latest/)
- [Link-local Address](https://en.wikipedia.org/wiki/Link-local_address)
- [Dynamic Configuration of IPv4 Link-Local Addresses](https://tools.ietf.org/html/rfc3927)
- [Openstack Metadata Service](https://docs.openstack.org/nova/latest/user/metadata-service.html)
