#!/bin/bash
set -e

echo "Fetching k3s binary ${K3S_VERSION}..."
curl -s -L -o /usr/local/bin/k3s "https://github.com/rancher/k3s/releases/download/v${K3S_VERSION}/k3s-armhf"
chmod 755 /usr/local/bin/k3s

#echo "Fetching k3s images tar"
#mkdir -p /var/lib/rancher/k3s/agent/images/
#curl -s -L -o /var/lib/rancher/k3s/agent/images/k3s-airgap-images-arm.tar "https://github.com/rancher/k3s/releases/download/v${K3S_VERSION}/k3s-airgap-images-arm.tar"

echo "Installing k3s as a Service..."

cat - > /etc/systemd/system/k3s.service <<'EOF'
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
After=network-online.target

[Install]
WantedBy=multi-user.target

[Service]
Type=exec
EnvironmentFile=/etc/systemd/system/k3s.service.env
KillMode=process
Delegate=yes
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Restart=always
RestartSec=5s
ExecStartPre=-/sbin/modprobe br_netfilter
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/k3s agent $K3S_EXEC_OPTS
EOF
chmod 0600 /etc/systemd/system/k3s.service

systemctl enable k3s.service

echo "k3s installation finished."
