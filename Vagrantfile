# -*- mode: ruby -*-
# vi: set ft=ruby :

vagrant_root = File.dirname(__FILE__)
Vagrant.configure("2") do |config|

  config.env.enable
  numberHaproxySrv=ENV["HAPROXY_NB"].to_i
  numberKnodeSrv=ENV["KNODE_NB"].to_i

  addIpsHost = "if ! grep -q kmaster /etc/hosts; then  sudo echo \""+ENV["KMASTER_IP"]+" kmaster\" >> /etc/hosts ;fi \n"
  (1..numberHaproxySrv).each do |i|
    addIpsHost += "if ! grep -q haproxy#{i} /etc/hosts; then  sudo echo \""+ENV["HAPROXY_IP_START"]+"#{i}  haproxy#{i}\" >> /etc/hosts ;fi \n"
  end
  (1..numberKnodeSrv).each do |i|
    addIpsHost += "if ! grep -q knode#{i} /etc/hosts; then  sudo echo \""+ENV["KNODE_IP_START"]+"#{i}  knode#{i}\" >> /etc/hosts ;fi \n"
  end
  config.vm.synced_folder ENV["NFS_PATH"], ENV["NFS_MOUNT"], type: "nfs"

  ###### HAPROXY
  (1..numberHaproxySrv).each do |i|
    config.vm.define "haproxy#{i}" do |haproxy|
      haproxy.vm.box = "debian/stretch64"
      haproxy.vm.hostname = "haproxy#{i}"
      haproxy.vm.network "private_network", ip: ENV["HAPROXY_IP_START"] + "#{i}"
      haproxy.vm.provider :virtualbox do |v|
        v.name
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--memory", ENV["HAPROXY_MEMORY"]]
        v.customize ["modifyvm", :id, "--name", "haproxy#{i}"]
        v.customize ["modifyvm", :id, "--cpus", ENV["HAPROXY_CPU"]]
      end
      haproxy.vm.provision "file", source: vagrant_root + "/config/bashrc", destination: "/home/vagrant/.bashrc"
      haproxy.vm.provision "file", source: vagrant_root + "/config/vimrc", destination: "/home/vagrant/.vimrc"
      haproxy.vm.provision "file", source: vagrant_root + "/config/haproxy.conf", destination: "/home/vagrant/haproxy.cfg"
      haproxy.vm.provision "file", source: vagrant_root + "/config/keepalived.conf", destination: "/home/vagrant/keepalived.conf"

      haproxy.vm.provision "shell", path: "script/common.sh"
      haproxy.vm.provision "shell", path: "script/haproxy.sh", args: [ENV["KEEPALIVED_IP"], ENV["KEEPALIVED_MASK"], ENV["KMASTER_IP"], ENV["HAPROXY_USER"], ENV["HAPROXY_PASSWORD"], ENV["KNODE_IP_START"], numberKnodeSrv]
      haproxy.vm.provision :shell, :inline => addIpsHost
    end
  end

  ###### KMASTER
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "debian/stretch64"
    kmaster.vm.hostname = "kmaster"
    kmaster.vm.box_url = "debian/stretch64"
    kmaster.vm.network :private_network, ip: ENV["KMASTER_IP"]
    kmaster.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      v.customize ["modifyvm", :id, "--memory", ENV["KMASTER_MEMORY"]]
      v.customize ["modifyvm", :id, "--name", "kmaster"]
      v.customize ["modifyvm", :id, "--cpus", ENV["KMASTER_CPU"]]
    end
    kmaster.vm.provision "file", source: vagrant_root + "/config/bashrc", destination: "/home/vagrant/.bashrc"
    kmaster.vm.provision "file", source: vagrant_root + "/config/vimrc", destination: "/home/vagrant/.vimrc"
    kmaster.vm.provision "file", source: vagrant_root + "/config/kube-flannel.yml", destination: "/home/vagrant/kube-flannel.yml"
    kmaster.vm.provision :shell, :inline => addIpsHost
    kmaster.vm.provision "shell", path: "script/common.sh"
    kmaster.vm.provision "shell", path: "script/kube.sh"
    kmaster.vm.provision "shell", path: "script/kmaster.sh", args: ENV["KUBE_TOKEN"]
  end

  ###### KNODE
  (1..numberKnodeSrv).each do |i|
    config.vm.define "knode#{i}" do |knode|
      knode.vm.box = "debian/stretch64"
      knode.vm.hostname = "knode#{i}"
      knode.vm.network "private_network", ip: ENV["KNODE_IP_START"] + "#{i}"
      knode.vm.provider :virtualbox do |v|
        v.name
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--memory", ENV["KNODE_MEMORY"]]
        v.customize ["modifyvm", :id, "--name", "knode#{i}"]
        v.customize ["modifyvm", :id, "--cpus", ENV["KNODE_CPU"]]
      end
      knode.vm.provision "file", source: vagrant_root + "/config/bashrc", destination: "/home/vagrant/.bashrc"
      knode.vm.provision "file", source: vagrant_root + "/config/vimrc", destination: "/home/vagrant/.vimrc"
      knode.vm.provision :shell, :inline => addIpsHost
      knode.vm.provision "shell", path: "script/common.sh"
      knode.vm.provision "shell", path: "script/kube.sh"
      knode.vm.provision "shell", path: "script/knode.sh", args: [ENV["KUBE_TOKEN"], ENV["KMASTER_IP"]]
    end
  end
end


