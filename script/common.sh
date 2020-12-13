#!/bin/bash


apt-get update
apt-get install -y --fix-missing apt-utils ca-certificates htop vim
## install common for k8s

cp /home/vagrant/.bashrc /root/.bashrc
cp /home/vagrant/.vimrc /root/.vimrc

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install common - "$IP

echo "[1]: add host name for ip"
host_exist=$(cat /etc/hosts | grep -i "$IP" | wc -l)
if [ "$host_exist" == "0" ];then
echo "$IP $HOSTNAME " >> /etc/hosts
fi

echo "[2]: disable swap"
# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

echo "[3]: install utils"
apt-get update -qq >/dev/null
apt-get install -y -qq apt-transport-https curl >/dev/null

echo "[4]: install docker if not exist"
if [ ! -f "/usr/bin/docker" ];then
curl -s -fsSL https://get.docker.com | sh; 
fi

echo "[5]: add kubernetes repository to source.list"
if [ ! -f "/etc/apt/sources.list.d/kubernetes.list" ];then
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
fi
apt-get update -qq >/dev/null

modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

echo "[6]: install kubelet / kubeadm / kubectl / kubernetes-cni"
apt-get install -y -qq kubelet kubeadm kubectl kubernetes-cni >/dev/null

echo "[6]: install tools"
apt-get install -y -qq htop >/dev/null

echo "END - install common - " $IP
