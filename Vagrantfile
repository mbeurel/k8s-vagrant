# -*- mode: ruby -*-
# vi: set ft=ruby :
vagrant_root = File.dirname(__FILE__)
Vagrant.configure("2") do |config|
  config.env.enable
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "debian/stretch64"
    kmaster.vm.hostname = "kmaster"
    kmaster.vm.box_url = "debian/stretch64"
    kmaster.vm.network :private_network, ip: ENV["KMASTER_IP"]
    kmaster.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", ENV["KMASTER_MEMORY"]]
      v.customize ["modifyvm", :id, "--name", "kmaster"]
      v.customize ["modifyvm", :id, "--cpus", ENV["KMASTER_CPU"]]
    end
    config.vm.provision "shell", inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      service ssh restart
    SHELL

    # Add .bashrc to vagrant User
    config.vm.provision "file", source: vagrant_root + "/config/bashrc", destination: "/home/vagrant/.bashrc"
    config.vm.provision "file", source: vagrant_root + "/config/vimrc", destination: "/home/vagrant/.vimrc"
    kmaster.vm.provision "shell", path: "script/common.sh"
    kmaster.vm.provision "shell", path: "script/master.sh", args: ENV["KUBE_TOKEN"]
    kmaster.vm.synced_folder ENV["KMASTER_NFS_PATH"], ENV["KMASTER_NFS_MOUNT"], type: "nfs"
  end

  numberSrv=ENV["KNODE_NB"].to_i
  # slave server
  (1..numberSrv).each do |i|
    config.vm.define "knode#{i}" do |knode|
      knode.vm.box = "debian/stretch64"
      knode.vm.hostname = "knode#{i}"
      knode.vm.network "private_network", ip: ENV["KNODE_IP_START"] + "#{i}"
      knode.vm.provider "virtualbox" do |v|
        v.name = "knode#{i}"
        v.memory = ENV["KNODE_MEMORY"]
        v.cpus = ENV["KNODE_CPU"]
      end
      config.vm.provision "shell", inline: <<-SHELL
        sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
        service ssh restart
      SHELL

      # Add .bashrc to vagrant User
      config.vm.provision "file", source: vagrant_root + "/config/bashrc", destination: "/home/vagrant/.bashrc"

      knode.vm.provision "shell", path: "script/common.sh"
      knode.vm.provision "shell", path: "script/node.sh", args: [ENV["KUBE_TOKEN"], ENV["KMASTER_IP"]]
    end
  end
end


