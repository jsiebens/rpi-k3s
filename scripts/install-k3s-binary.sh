#!/bin/bash
set -e

echo "Fetching k3s binary ${K3S_VERSION}..."
curl -s -L -o /usr/local/bin/k3s "https://github.com/rancher/k3s/releases/download/v${K3S_VERSION}/k3s-armhf"
chmod 755 /usr/local/bin/k3s

#echo "Fetching k3s images tar"
#mkdir -p /var/lib/rancher/k3s/agent/images/
#curl -s -L -o /var/lib/rancher/k3s/agent/images/k3s-airgap-images-arm.tar "https://github.com/rancher/k3s/releases/download/v${K3S_VERSION}/k3s-airgap-images-arm.tar"