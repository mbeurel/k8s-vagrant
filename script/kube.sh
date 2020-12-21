#!/bin/bash
echo "
############################
  Install to All Kube machines
############################"


echo "[1] - Install Docker"
if [ ! -f "/usr/bin/docker" ];then
curl -s -fsSL https://get.docker.com | sh;
fi
usermod -aG docker vagrant

echo "[2] - Add kubernetes repository to source.list"
if [ ! -f "/etc/apt/sources.list.d/kubernetes.list" ];then
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
fi
apt-get update -qq >/dev/null


echo "[3] - IPV6"
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

echo "[4] - Install kubelet / kubeadm / kubectl / kubernetes-cni"
apt-get install -y -qq kubelet kubeadm kubectl kubernetes-cni >/dev/null

echo "[5] - Install Kube autocompletion"
kubectl completion bash >/etc/bash_completion.d/kubectl