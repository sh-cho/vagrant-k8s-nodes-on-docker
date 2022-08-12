# -*- mode: ruby -*-
# vi: set ft=ruby :

# max number of worker nodes
N = 3

Vagrant.configure("2") do |config|
  #=============#
  # Master Node #
  #=============#
  config.ssh.insert_key = false

  config.vm.define "m-k8s-1.24" do |cfg|
    cfg.vm.provider :docker do |docker, override|
      override.vm.box = nil
      docker.image = "seonghyeon/vagrant-docker-provider:rockylinux8-systemd"
      docker.remains_running = true
      docker.has_ssh = true
      docker.privileged = true
      docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
      docker.create_args = ["--cgroupns=host", "--platform=linux/arm64", "--cpuset-cpus=2", "--memory=3g"]
    end
    cfg.vm.host_name = "m-k8s"
    cfg.vm.network "private_network", ip: "192.168.1.10"
    cfg.vm.network "forwarded_port", guest: 22, host: 60010, auto_correct: true, id: "ssh"
    cfg.vm.synced_folder "../data", "/vagrant", disabled: true
    cfg.vm.provision :shell, :inline => "ulimit -n 4048"
    cfg.vm.provision "shell", path: "build.sh", args: N
    cfg.vm.provision "shell", path: "_master_node.sh"
  end

  #==============#
  # Worker Nodes #
  #==============#
  (1..N).each do |i|
    config.vm.define "w#{i}-k8s-1.24" do |cfg|
      cfg.vm.provider :docker do |docker, override|
        override.vm.box = nil
        docker.image = "seonghyeon/vagrant-docker-provider:rockylinux8-systemd"
        docker.remains_running = true
        docker.has_ssh = true
        docker.privileged = true
        docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
        docker.create_args = ["--cgroupns=host", "--platform=linux/arm64", "--cpuset-cpus=1", "--memory=2g"]
      end
      cfg.vm.host_name = "w#{i}-k8s"
      cfg.vm.network "private_network", ip: "192.168.1.10#{i}"
      cfg.vm.network "forwarded_port", guest: 22, host: "6010#{i}", auto_correct: true, id: "ssh"
      cfg.vm.synced_folder "../data", "/vagrant", disabled: true
      cfg.vm.provision "shell", path: "build.sh", args: N
      cfg.vm.provision "shell", path: "_worker_nodes.sh"
    end
  end
end
