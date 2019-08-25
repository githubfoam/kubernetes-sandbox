#!/bin/bash
# Container runtimes
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# Install Docker CE
# Set up the repository:
## Install packages to allow apt to use a repository over HTTPS
apt-get update
apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
## Install Docker CE.
apt-get update && apt-get install docker-ce=18.06.2~ce~3-0~ubuntu -y
echo "====================================================================================="
docker -v
echo "====================================================================================="
# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
# Restart docker.
systemctl daemon-reload
systemctl restart docker
# Installing kubeadm
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
echo "=============================kubeadm========================================================"
kubeadm version
echo "============================================================================================"
echo "=============================kubectl========================================================"
kubectl version
echo "============================================================================================"
echo "=============================kubelet========================================================"
kubelet --version
echo "============================================================================================"
hostnamectl status
cat << EOF > /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd
Restart=always
EOF
systemctl daemon-reload
systemctl restart kubelet
hostnamectl status
