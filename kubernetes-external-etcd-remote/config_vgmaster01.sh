#!/bin/bash
cat <<EOT | sudo tee kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "192.168.10.5"
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
apiServer:
  certSANs:
  - 192.168.10.1
  extraArgs:
    advertise-address: 192.168.10.1
controlPlaneEndpoint: 192.168.10.1:6443
etcd:
    external:
        endpoints:
        - https://192.168.10.2:2379
        - https://192.168.10.3:2379
        - https://192.168.10.4:2379
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
networking:
  podSubnet: 192.168.0.0/16
EOT
mkdir -p /etc/kubernetes/pki/etcd/
cp /tmp/etcd/ca.crt /etc/kubernetes/pki/etcd/
cp /tmp/apiserver-etcd-client.crt /etc/kubernetes/pki/
cp /tmp/apiserver-etcd-client.key /etc/kubernetes/pki/
hostnamectl status
