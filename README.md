# Vagrant

K8S in to vagrant configuration.
K8S config used : kubelet kubeadm kubectl kubernetes-cni.

## Config

**Copy environnement file**
```bash
cp .env.dist .env
```

**Edit environnement file**
```bash
vi .env
```
_Enter your parameters_

**Start Vagrant**
```bash
vagrant up
```

**Connect Kmaster**
```bash
vagrant ssh kmaster
```

**Check K8s nodes status**
```bash
watch kubectl get nodes -o wide
```

Great, your virtual machine and K8S is start !!

## Credits

Created by [Matthieu Beurel](https://www.mbeurel.com). Sponsored by [Nexboard](https://www.nexboard.fr).