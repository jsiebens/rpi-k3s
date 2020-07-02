#!/bin/bash
set -e

K3S_ARCH=armhf

if [[ $PACKER_BUILD_NAME == *"arm64"* ]]; then
  K3S_ARCH=arm64
fi


echo "Fetching k3s binary ${K3S_VERSION} ${K3S_ARCH} ..."
curl -s -L -o /usr/local/bin/k3s "https://github.com/rancher/k3s/releases/download/v${K3S_VERSION}/k3s-${K3S_ARCH}"
chmod 755 /usr/local/bin/k3s

#echo "Fetching k3s images tar"
#mkdir -p /var/lib/rancher/k3s/agent/images/
#curl -s -L -o /var/lib/rancher/k3s/agent/images/k3s-airgap-images-arm.tar "https://github.com/rancher/k3s/releases/download/v${K3S_VERSION}/k3s-airgap-images-arm.tar"