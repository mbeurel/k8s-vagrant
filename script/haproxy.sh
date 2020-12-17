#!/bin/bash
echo "
############################
  Install to HAPROXY machines
############################"

IP_VIRTUAL=$1
IP_MASK=$2

KMASTER_IP=$3
HAPROXY_USER=$4
HAPROXY_PASSWORD=$5

KNODE_IP_START=$6
KNODE_NB=$7

KNODE_SERVER=""
KNODE_SERVER_SSL=""
for ((i=1; i<=KNODE_NB; i++)); do
  KNODE_SERVER+="  server knode$i $KNODE_IP_START$i:80 check \n"
  KNODE_SERVER_SSL+="  server knode$i $KNODE_IP_START$i:443 check \n"
done

echo $KNODE_SERVER
echo $KNODE_SERVER_SSL

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - Install common "$HOSTNAME" - IP :"$IP

echo "[1] - Install tools paquet"
apt-get update
apt-get install -y --fix-missing keepalived haproxy psmisc
sudo setsebool -P haproxy_connect_any=1

echo "[2] - Copy config Keepalive and Haproxy"
cp /home/vagrant/keepalived.conf /etc/keepalived/keepalived.conf
cp /home/vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg

sed -i "s/__IP_VIRTUAL__/$IP_VIRTUAL/g" /etc/keepalived/keepalived.conf
sed -i "s/__IP_MASK__/$IP_MASK/g" /etc/keepalived/keepalived.conf

sed -i "s/__KMASTER_IP__/$KMASTER_IP/g" /etc/haproxy/haproxy.cfg
sed -i "s/__USER__/$HAPROXY_USER/g" /etc/haproxy/haproxy.cfg
sed -i "s/__PASSWORD__/$HAPROXY_PASSWORD/g" /etc/haproxy/haproxy.cfg
sed -i "s/__SERVER__/$KNODE_SERVER/g" /etc/haproxy/haproxy.cfg
sed -i "s/__SERVER_SSL__/$KNODE_SERVER_SSL/g" /etc/haproxy/haproxy.cfg


echo "[2] - Restart Keepalive and Haproxy"
systemctl restart haproxy
systemctl restart keepalived