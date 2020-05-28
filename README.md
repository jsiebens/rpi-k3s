# k3s on a Raspberry Pi

[![Build Status](https://travis-ci.org/jsiebens/rpi-k3s.svg?branch=master)](https://travis-ci.org/jsiebens/rpi-k3s)

This repository contains Packer templates and scripts to build a Raspbian image with [k3s](https://github.com/rancher/k3s) pre-installed.

> k3s: Lightweight Kubernetes. Easy to install, half the memory, all in a binary less than 100 MB.

This setup includes the following images:

- __k3s-agent.img__: a Raspbian image with k3s as a systemd services, configured to run as agent (`k3s agent`). 

- __k3s-server.img__: a Raspbian image with k3s as a systemd services, configured to run as server (`k3s server`).

