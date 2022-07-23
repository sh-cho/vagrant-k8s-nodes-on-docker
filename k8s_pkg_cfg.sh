#!/usr/bin/env bash

# install util packages
sudo yum install epel-release -y
sudo yum install vim-enhanced -y
sudo yum install git -y

# install docker
sudo yum install docker-ce-$2 docker-ce-cli-$2 containerd.io-$3 -y

# install kubernetes
# both kubelet and kubectl will install by dependency
# but aim to latest version. so fixed version by manually
sudo yum install kubelet-$1 kubectl-$1 kubeadm-$1 -y --disableexcludes=kubernetes

# Ready to install for k8s
sudo systemctl enable --now docker
sudo systemctl enable --now kubelet
