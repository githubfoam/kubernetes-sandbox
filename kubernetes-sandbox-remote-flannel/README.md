# kubernetes sandbox

cross platform(freebsd,lin,win,mac..etc)
~~~~
Container runtimes
On each of your machines, install Docker. Version 18.06.2 is recommended, but 1.11, 1.12, 1.13, 17.03 and 18.09 are known to work as well. Keep track of the latest verified Docker version in the Kubernetes release notes.
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

 Version 18.06.2 is recommended, only docker-ce
- 'docker-ce{{ validated_dockerv }}'
# - 'docker-ce-cli{{ validated_dockerv }}'
# - containerd.io

v1.15 Release Notes
The list of validated docker versions remains unchanged.
The current list is 1.13.1, 17.03, 17.06, 17.09, 18.06, 18.09. (#72823, #72831)
https://kubernetes.io/docs/setup/release/notes/

~~~~

~~~~
Install Docker CE
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

### Add Docker apt repository.
add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) \
 stable"

## Install Docker CE.
apt-get update && apt-get install docker-ce=18.06.2~ce~3-0~ubuntu

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

~~~~
~~~~
Swap disabled. You MUST disable swap in order for the kubelet to work properly
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#configure-cgroup-driver-used-by-kubelet-on-control-plane-node
~~~~
~~~~
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#configure-cgroup-driver-used-by-kubelet-on-control-plane-node
~~~~
~~~~
install only one pod network per cluster.
For flannel to work correctly, you must pass --pod-network-cidr=10.244.0.0/16 to kubeadm init.
Set /proc/sys/net/bridge/bridge-nf-call-iptables to 1 by running sysctl net.bridge.bridge-nf-call-iptables=1
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
~~~~
~~~~
The Inventory File

Auto-Generated Inventory
The first and simplest option is to not provide one to Vagrant at all. Vagrant will generate an inventory file encompassing all of the virtual machines it manages, and use it for provisioning machines

Static Inventory
The second option is for situations where you would like to have more control over the inventory management.
With the inventory_path option, you can reference a specific inventory resource (e.g. a static inventory file, a dynamic inventory script or even multiple inventories stored in the same directory)
https://www.vagrantup.com/docs/provisioning/ansible_intro.html
~~~~

~~~~
vagrant@k8s-master:~$ apt-cache madison docker-ce
 docker-ce | 5:19.03.1~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:19.03.0~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.8~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.7~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.6~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.5~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.4~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.3~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.2~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.1~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
 docker-ce | 5:18.09.0~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages

 vagrant@k8s-master:~$ apt-cache madison kubelet
    kubelet |  1.15.2-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
    kubelet |  1.15.1-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
    kubelet |  1.15.0-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
    kubelet |  1.14.5-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
    kubelet |  1.14.4-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
    kubelet |  1.14.3-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages

~~~~
~~~~
>vagrant global-status
id       name            provider   state    directory
-----------------------------------------------------------------------------------------------------------
c34c93c  k8s-master01    virtualbox running  C:/multimachine/kubernetes-sandbox-remote
adb4ffe  worker01        virtualbox running  C:/multimachine/kubernetes-sandbox-remote
2e21187  worker02        virtualbox running  C:/multimachine/kubernetes-sandbox-remote
b39b49d  remotecontrol01 virtualbox running  C:/multimachine/kubernetes-sandbox-remote

>vagrant ssh remotecontrol01

vagrant@remotecontrol01:~$ history
    1  sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/00_initial.yml
    2  sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/01_kube-dependencies.yml
    3  sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/02_masters.yml
    4  sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/03_workers.yml
    5  sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/04_clients.yml                                         

~~~~

~~~~
vagrant@remotecontrol01:~$ kubectl get nodes
NAME           STATUS   ROLES    AGE     VERSION
k8s-master01   Ready    master   8m39s   v1.15.3
worker01       Ready    <none>   6m19s   v1.15.3
worker02       Ready    <none>   6m13s   v1.15.3
vagrant@k8s-master01:~$ kubectl get pods --all-namespaces
NAMESPACE         NAME                                   READY   STATUS    RESTARTS   AGE
heptio-sonobuoy   sonobuoy                               1/1     Running   0          11m
kube-system       coredns-5c98db65d4-4dp68               1/1     Running   0          49m
kube-system       coredns-5c98db65d4-dq57s               1/1     Running   0          49m
kube-system       etcd-k8s-master01                      1/1     Running   0          48m
kube-system       kube-apiserver-k8s-master01            1/1     Running   0          48m
kube-system       kube-controller-manager-k8s-master01   1/1     Running   0          49m
kube-system       kube-flannel-ds-amd64-5kzjc            1/1     Running   0          47m
kube-system       kube-flannel-ds-amd64-jtfrv            1/1     Running   0          47m
kube-system       kube-flannel-ds-amd64-pd7m4            1/1     Running   0          49m
kube-system       kube-proxy-bbfx2                       1/1     Running   0          49m
kube-system       kube-proxy-rgh55                       1/1     Running   0          47m
kube-system       kube-proxy-v8hzl                       1/1     Running   0          47m
kube-system       kube-scheduler-k8s-master01            1/1     Running   0          48m
~~~~
