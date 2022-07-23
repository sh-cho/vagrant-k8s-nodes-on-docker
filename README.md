# vagrant-k8s-nodes-on-docker

## why?

VirtualBox doesn't support ARM64 architecture, and I only have a m1 Macbook.

## info

- image: [`seonghyeon/vagrant-docker-provider:rockylinux8-systemd`](https://github.com/sh-cho/vagrant-docker-provider)
- nodes spec (see [Vagrantfile](Vagrantfile))
  - 1 master node (2 core + 3G memory)
  - 3 worker nodes (1 core + 2G memory)

## how to use

```sh
vagrant up --provider=docker
```
Startup nodes

```sh
vagrant destroy -f
```
When something went wrong

## credit
- https://github.com/sysnet4admin/_Lecture_k8s_starter.kit ([lecture](https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EC%89%BD%EA%B2%8C%EC%8B%9C%EC%9E%91))
