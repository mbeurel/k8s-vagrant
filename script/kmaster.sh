#!/bin/bash
echo "
############################
  Install to Kube Node machines
############################"
TOKEN=$1
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install Kube Master -> IP : "$IP

echo "[0] - Reset cluster if exist"
kubeadm reset -f

echo "[1] - Kubadm init -> TOKEN : $TOKEN"
kubeadm init --apiserver-advertise-address=$IP --token="$TOKEN" --pod-network-cidr=10.244.0.0/16

echo "[3]: create config file"
mkdir $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config

echo "[4] - Apply flannel pods network"
kubectl apply -f /home/vagrant/kube-flannel.yml

echo "[5] - Restart and enable kubelet"
systemctl enable kubelet
service kubelet restart

echo "[6] - Config Kubectl to vagrant User"
kubectl completion bash > /etc/bash_completion.d/kubectl
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "END - install Kube Master -> IP : "$IP

