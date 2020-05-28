# k3s on a Raspberry Pi

[![Build Status](https://travis-ci.org/jsiebens/rpi-k3s.svg?branch=master)](https://travis-ci.org/jsiebens/rpi-k3s)

This repository contains Packer templates and scripts to build a Raspbian image with [k3s](https://github.com/rancher/k3s) pre-installed.

> k3s: Lightweight Kubernetes. Easy to install, half the memory, all in a binary less than 100 MB.

Beside k3s, also [cloud-init](https://cloudinit.readthedocs.io/en/18.3/) is available to initialize and configure a Raspian instance. With cloud-init you can customize e.g. hostname, authorized ssh keys, a static ip, token for k3s, ... 


This setup includes the following images:

- __k3s-agent.img__: a Raspbian image with k3s as a systemd service, configured to run as agent (`k3s agent`). 

- __k3s-server.img__: a Raspbian image with k3s as a systemd service, configured to run as server (`k3s server`).


## How to use these images

1. Download the image of the latest [release](https://github.com/jsiebens/rpi-faasd/releases) or build the image.

2. Flash the image to an SD card.

3. Customize the /boot/user-data with e.g. authorized ssh keys, k3s environment variables ...

4. Insert the SD card into the Raspberry Pi and power it up.

5. A few moments later, the k3s will be up and running


## Building a k3s cluster

### Preparing the master node

After downloading and writing the image to an SD card, edit the cloud-init `/boot/user-data` file to:

- configure a hostname

- configure the k3s token

- configure a static ip address

E.g.

```
#cloud-config
# vim: syntax=yaml
#

# Set your hostname here, the manage_etc_hosts will update the hosts file entries as well
hostname: k3s-server
manage_etc_hosts: true

write_files:
# Configure k3s environment file
- path: /etc/systemd/system/k3s.service.env
  content: |
    K3S_TOKEN=i1F2tDzvHQsWvy5MnDsF
    K3S_KUBECONFIG_OUTPUT=/etc/k3s/kubeconfig.yaml
    K3S_KUBECONFIG_MODE=666
# Configure a static ip address for the master
- path: /etc/dhcpcd.conf
  content: |
    persistent
    # Generate Stable Private IPv6 Addresses instead of hardware based ones
    slaac private

    # static IP configuration:
    interface eth0
    static ip_address=192.168.0.30/24
    static routers=192.168.0.1
    static domain_name_servers=192.168.0.1 8.8.8.8
```

### Preparing the agent nodes

After downloading and writing the image to an SD card, edit the cloud-init `/boot/user-data` file to:

- configure a hostname

- configure the k3s token

- configure the k3s url (to join the master node)

E.g.

```
#cloud-config
# vim: syntax=yaml
#

# Set your hostname here, the manage_etc_hosts will update the hosts file entries as well
hostname: k3s-agent
manage_etc_hosts: true

write_files:
# Configure k3s environment file
- path: /etc/systemd/system/k3s.service.env
  content: |
    K3S_TOKEN=i1F2tDzvHQsWvy5MnDsF
    K3S_URL=https://192.168.0.30:6443
```

>If you are adding multiple agents, make sure you give them unique hostnames!


__pro tip:__

[flash](https://github.com/hypriot/flash) is a command line script to write SD card images of any kind, with handy features like adding user-data and setting the hostname.

E.g.

```
flash --hostname k3s-server --user-data example/k3s-server.yaml
flash --hostname k3s-agent-001 --user-data example/k3s-agent.yaml
flash --hostname k3s-agent-002 --user-data example/k3s-agent.yaml
flash --hostname k3s-agent-003 --user-data example/k3s-agent.yaml
```

### Accessing your cluster

After booting all master and agent Raspberry Pi, ssh into your master node to get the kubeconfig file located at e.g. `/etc/k3s/kubeconfig.yaml`, depending on the `K3S_KUBECONFIG_OUTPUT` variable. Use this file to configure `kubectl` and you are good to go.


## Building the images

This project includes a Vagrant file and some scripts to build the images in an isolated environment.

To use the Vagrant environment, start by cloning this repository:

```
git clone https://github.com/jsiebens/rpi-k3s
cd rpi-faasd
```

Next, start the Vagrant box and ssh into it:

```
vagrant up
vagrant ssh
```

When connected with the Vagrant box, run `make` in the `/vagrant` directory:

```
cd /vagrant
make
```