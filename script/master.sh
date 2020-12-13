#!/bin/bash


## install master for k8s
TOKEN=$1
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install master - "$IP

echo "[0]: reset cluster if exist"
kubeadm reset -f

echo "[1]: kubadm init -> TOKEN : $TOKEN"
kubeadm init --apiserver-advertise-address=$IP --token="$TOKEN" --pod-network-cidr=10.244.0.0/16

echo "[2]: create config file"
mkdir $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config

echo "[3]: create flannel pods network"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "[4]: restart and enable kubelet"
systemctl enable kubelet
service kubelet restart

echo "[5]: Config Kubectl to vagrant User"
kubectl completion bash >/etc/bash_completion.d/kubectl
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "[6]: install git"
apt-get install -y -qq git >/dev/null

echo "END - install master - " $IP

