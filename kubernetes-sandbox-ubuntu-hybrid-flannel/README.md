# kubernetes sandbox

~~~~
cross platform (freebsd,lin,win,mac..etc)
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
v1.15 Release Notes
The list of validated docker versions remains unchanged.
The current list is 1.13.1, 17.03, 17.06, 17.09, 18.06, 18.09. (#72823, #72831)
https://kubernetes.io/docs/setup/release/notes/

Container runtimes
On each of your machines, install Docker. Version 18.06.2 is recommended, but 1.11, 1.12, 1.13, 17.03 and 18.09 are known to work as well. Keep track of the latest verified Docker version in the Kubernetes release notes.
https://kubernetes.io/docs/setup/production-environment/container-runtimes/

[WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/

~~~~

~~~~
flannel pod network
https://github.com/coreos/flannel#flannel
Cluster Networking
https://kubernetes.io/docs/concepts/cluster-administration/networking/

~~~~

~~~~
vagrant up
or
vagrant up k8s-master
vagrant up node-1
vagrant up node-2
~~~~
hybrid-cluster
~~~~
==> k8s-master: Running provisioner: shell...
    k8s-master: Running: inline script
    k8s-master:    Static hostname: k8s-master
    k8s-master:          Icon name: computer-vm
    k8s-master:            Chassis: vm
    k8s-master:         Machine ID: 1d351a2688d84f06b0321cb3fa9e567a
    k8s-master:            Boot ID: 4fe091e276184136b36a4c33ce936e43
    k8s-master:     Virtualization: oracle
    k8s-master:   Operating System: Ubuntu 18.10
    k8s-master:             Kernel: Linux 4.18.0-10-generic
    k8s-master:       Architecture: x86-64
==> node-1: Running provisioner: shell...
    node-1: Running: inline script
    node-1:    Static hostname: node-1
    node-1:          Icon name: computer-vm
    node-1:            Chassis: vm
    node-1:         Machine ID: 997658dc84144743aa73c57e057814c3
    node-1:            Boot ID: bedd9d20ad5141728d78136f3dc31a3f
    node-1:     Virtualization: oracle
    node-1:   Operating System: Ubuntu 19.04
    node-1:             Kernel: Linux 5.0.0-17-generic
    node-1:       Architecture: x86-64
==> node-2: Running provisioner: shell...
    node-2: Running: inline script
    node-2:    Static hostname: node-2
    node-2:          Icon name: computer-vm
    node-2:            Chassis: vm
    node-2:         Machine ID: b4d34378b21de2b163f4308a5c266ccb
    node-2:            Boot ID: 7a15d91b1a614a2f89a06618c60d1cdf
    node-2:     Virtualization: oracle
    node-2:   Operating System: Ubuntu 16.04.5 LTS
    node-2:             Kernel: Linux 4.4.0-131-generic
    node-2:       Architecture: x86-64

~~~~

~~~~

vagrant ssh k8s-master
vagrant@k8s-master:~$ kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   55m   v1.15.2
node-1       Ready    <none>   46m   v1.15.2
~~~~
node-2 added after cluster booted
~~~~
vagrant ssh node-2
vagrant@k8s-master:~$ kubectl get nodes
NAME         STATUS   ROLES    AGE    VERSION
k8s-master   Ready    master   85m    v1.15.2
node-1       Ready    <none>   76m    v1.15.2
node-2       Ready    <none>   3m1s   v1.15.2
~~~~
