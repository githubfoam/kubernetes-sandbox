# kubernetes sandbox
cross platform(freebsd,lin,win,mac..etc)
~~~~
$ sonobuoy run --wait
Running plugins: e2e, systemd-logs
ERRO[0000] Preflight checks failed
ERRO[0000] maximum kubernetes version is 1.14.99, got v1.15.2

https://github.com/cncf/k8s-conformance/tree/master/v1.15/kubeadm
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


vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/initial.yml
vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/masters.yml                                          
vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/workers.yml
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
vagrant@k8s-master01:~$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master01   Ready    master   14m   v1.15.2
worker01       Ready    <none>   11m   v1.15.2
worker02       Ready    <none>   11m   v1.15.2
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

~~~~
vagrant@k8s-master01:~$ curl -sSL https://github.com/heptio/sonobuoy/releases/download/v0.14.3/sonobuoy_0.14.3_linux_amd64.tar.gz | sudo tar -xz --exclude LICENSE -C /usr/bin
vagrant@k8s-master01:~$ sonobuoy run --wait


# Run end to end tests
sonobuoy run --wait --skip-preflight
# Fetch the results
results=$(sonobuoy retrieve)
sonobuoy e2e $results
sonobuoy delete --all

vagrant@k8s-master01:~$ kubectl get all --all-namespaces | grep sonobuoy
heptio-sonobuoy   pod/sonobuoy                               1/1     Running   0          10m
heptio-sonobuoy   service/sonobuoy-master   ClusterIP   10.110.6.75   <none>        8080/TCP                 10m

~~~~


~~~~
https://github.com/cncf/k8s-conformance/tree/master/v1.15/kubeadm
https://github.com/heptio/sonobuoy

v1.15 Release Notes
The list of validated docker versions remains unchanged.
The current list is 1.13.1, 17.03, 17.06, 17.09, 18.06, 18.09. (#72823, #72831)
https://kubernetes.io/docs/setup/release/notes/

Container runtimes
On each of your machines, install Docker. Version 18.06.2 is recommended, but 1.11, 1.12, 1.13, 17.03 and 18.09 are known to work as well. Keep track of the latest verified Docker version in the Kubernetes release notes.
https://kubernetes.io/docs/setup/production-environment/container-runtimes/

[WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/

~~~~
