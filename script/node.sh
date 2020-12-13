#!/bin/bash
## install nodes for k8s
TOKEN=$1
KMASTER_IP=$2
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install node - "$IP

echo "[0]: reset cluster if exist"
kubeadm reset -f

echo "[1]: kubadm join  -> TOKEN : $TOKEN -> KMASTER IP : $KMASTER_IP"
kubeadm join --ignore-preflight-errors=all --token="$TOKEN" $KMASTER_IP:6443 --discovery-token-unsafe-skip-ca-verification

echo "[2]: restart and enable kubelet"
systemctl enable kubelet
service kubelet restart

echo "END - install node - " $IP
