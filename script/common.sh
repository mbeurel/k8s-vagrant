#!/bin/bash
echo "
############################
  Install to All machines
############################"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - Install common "$HOSTNAME" - IP :"$IP

echo "[1] - Install tools paquet"
apt-get update
apt-get install -y --fix-missing apt-utils ca-certificates apt-transport-https curl htop vim net-tools git python3-pip telnet
## install common for k8s

echo "[2] - Add Bashrc and vim config user"
cp /home/vagrant/.bashrc /root/.bashrc
cp /home/vagrant/.vimrc /root/.vimrc

echo "[3] - add host name for ip"
host_exist=$(cat /etc/hosts | grep -i "$IP" | wc -l)
if [ "$host_exist" == "0" ];then
echo "$IP $HOSTNAME " >> /etc/hosts
fi

echo "[4]: disable swap"
# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

echo "[5]: Active SSH connextion"
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "END - Install common "$HOSTNAME" - IP :"$IP
