# -*- mode: ruby -*-
# vi: set ft=ruby :

## configuration variables ##
# max number of worker nodes
N = 3

# each of components to install
k8s_V = '1.20.2'
docker_V = '19.03.14-3.el8'
ctrd_V = '1.3.9-3.1.el8'
## /configuration variables ##

Vagrant.configure("2") do |config|
  #=============#
  # Master Node #
  #=============#
  config.ssh.insert_key = false

  config.vm.define "m-k8s-#{k8s_V[0..3]}" do |cfg|
    cfg.vm.provider :docker do |docker, override|
      override.vm.box = nil
      docker.image = "seonghyeon/vagrant-docker-provider:rockylinux8-systemd"
      docker.remains_running = true
      docker.has_ssh = true
      docker.privileged = true
      docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
      docker.create_args = ["--cgroupns=host", "--platform=linux/arm64"]
      docker.create_args = ["--cpuset-cpu=2", "--memory=3g"]
    end
    cfg.vm.host_name = "m-k8s"
    cfg.vm.network "private_network", ip: "192.168.1.10"
    cfg.vm.network "forwarded_port", guest: 22, host: 60010, auto_correct: true, id: "ssh"
    cfg.vm.synced_folder "../data", "/vagrant", disabled: true 
    cfg.vm.provision :shell, :inline => "ulimit -n 4048"
    cfg.vm.provision "shell", path: "k8s_env_build.sh", args: N
    cfg.vm.provision "shell", path: "k8s_pkg_cfg.sh", args: [ k8s_V, docker_V, ctrd_V ]
    cfg.vm.provision "shell", path: "_master_node.sh"
  end

  #==============#
  # Worker Nodes #
  #==============#
  (1..N).each do |i|
    config.vm.define "w#{i}-k8s-#{k8s_V[0..3]}" do |cfg|
      cfg.vm.provider :docker do |docker, override|
        override.vm.box = nil
        docker.image = "seonghyeon/vagrant-docker-provider:rockylinux8-systemd"
        docker.remains_running = true
        docker.has_ssh = true
        docker.privileged = true
        docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
        docker.create_args = ["--cgroupns=host", "--platform=linux/arm64"]
        docker.create_args = ["--cpuset-cpu=1", "--memory=2g"]
      end
      cfg.vm.host_name = "w#{i}-k8s"
      cfg.vm.network "private_network", ip: "192.168.1.10#{i}"
      cfg.vm.network "forwarded_port", guest: 22, host: "6010#{i}", auto_correct: true, id: "ssh"
      cfg.vm.synced_folder "../data", "/vagrant", disabled: true
      cfg.vm.provision "shell", path: "k8s_env_build.sh", args: N
      cfg.vm.provision "shell", path: "k8s_pkg_cfg.sh", args: [ k8s_V, docker_V, ctrd_V ]
      cfg.vm.provision "shell", path: "_worker_nodes.sh"
    end
  end
end
