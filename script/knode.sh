#!/bin/bash
echo "
############################
  Install to Kube Node machines
############################"
TOKEN=$1
KMASTER_IP=$2
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install Kube Node -> IP : "$IP

echo "[0] - Reset cluster if exist"
kubeadm reset -f

echo "[1] - Kubadm join  -> TOKEN : $TOKEN -> KMASTER IP : $KMASTER_IP"
kubeadm join --ignore-preflight-errors=all --token="$TOKEN" $KMASTER_IP:6443 --discovery-token-unsafe-skip-ca-verification

echo "[2] - Restart and enable kubelet"
systemctl enable kubelet
service kubelet restart

echo "END - Install Kube Node -> IP : "$IP
