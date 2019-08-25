#!/bin/bash
# Installing kubeadm
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubectl
apt-mark hold kubelet kubeadm kubectl
mkdir ~/.kube
echo "=============================kubectl========================================================"
kubectl version
echo "============================================================================================"
hostnamectl status
