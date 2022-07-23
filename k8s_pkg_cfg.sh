#!/usr/bin/env bash

# install util packages
sudo yum install epel-release vim-enhanced git iproute-tc -y

# install docker
sudo yum install docker-ce-$2 docker-ce-cli-$2 containerd.io-$3 -y
# mkdir /etc/docker
# cat <<EOF > /etc/docker/daemon.json
# {
#   "exec-opts": ["native.cgroupdriver=systemd"],
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "100m"
#   },
#   "storage-driver": "overlay2",
#   "storage-opts": [
#     "overlay2.override_kernel_check=true"
#   ]
# }
# EOF

# install kubernetes
# both kubelet and kubectl will install by dependency
# but aim to latest version. so fixed version by manually
sudo yum install kubelet-$1 kubectl-$1 kubeadm-$1 -y --disableexcludes=kubernetes

# Ready to install for k8s
sudo systemctl enable --now docker
sudo systemctl enable --now kubelet
