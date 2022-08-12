#!/usr/bin/env bash


kube_version='1.24.3'
containerd_version='1.6.7'


# vim configuration
echo 'alias vi=vim' >> /etc/profile

# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# kubernetes repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-aarch64
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
# sudo setenforce 0
# sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# mkdir -p /etc/modules-load.d/
# cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
# overlay
# br_netfilter
# EOF

# sudo modprobe overlay
# sudo modprobe br_netfilter

# # sysctl params required by setup, params persist across reboots
# # mkdir -p /etc/sysctl.d/
# cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
# net.bridge.bridge-nf-call-iptables  = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# net.ipv4.ip_forward                 = 1
# EOF

# # Apply sysctl params without reboot
# sudo sysctl --system

# add docker-ce repo
yum install yum-utils -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# local small dns & vagrant cannot parse and delivery shell code.
echo "192.168.1.10 m-k8s" >> /etc/hosts
for (( i=1; i<=$1; i++  )); do echo "192.168.1.10$i w$i-k8s" >> /etc/hosts; done

# config DNS
cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF


# install util packages
sudo yum install epel-release vim-enhanced git iproute-tc -y

# install container runtime
sudo yum install containerd.io cri-tools -y

containerd config default > /etc/containerd/config.toml
sed -i '/plugins."io.containerd.grpc.v1.cri".containerd.default_runtime.options/a\          SystemdCgroup = true' /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

sudo crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock --set image-endpoint=unix:///run/containerd/containerd.sock
crictl ps

# install kubernetes
# both kubelet and kubectl will install by dependency
# but aim to latest version. so fixed version by manually
sudo yum install kubelet-${kube_version} kubectl-${kube_version} kubeadm-${kube_version} -y --disableexcludes=kubernetes

# Ready to install for k8s
sudo systemctl enable --now kubelet
