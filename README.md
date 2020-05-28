# k3s on a Raspberry Pi

[![Build Status](https://travis-ci.org/jsiebens/rpi-k3s.svg?branch=master)](https://travis-ci.org/jsiebens/rpi-k3s)

This repository contains Packer templates and scripts to build a Raspbian image with [k3s](https://github.com/rancher/k3s) pre-installed.

> k3s: Lightweight Kubernetes. Easy to install, half the memory, all in a binary less than 100 MB.

Beside k3s, also [cloud-init](https://cloudinit.readthedocs.io/en/18.3/) is available to initialize and configure a Raspian instance. With cloud-init you can customize e.g. hostname, authorized ssh keys, a static ip, token for k3s, ... 


This setup includes the following images:

- __k3s-agent.img__: a Raspbian image with k3s as a systemd service, configured to run as agent (`k3s agent`). 

- __k3s-server.img__: a Raspbian image with k3s as a systemd service, configured to run as server (`k3s server`).


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