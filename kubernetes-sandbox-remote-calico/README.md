# kubernetes sandbox

~~~~
cross platform(freebsd,lin,win,mac..etc)

vagrant global-status
id       name            provider   state    directory
-----------------------------------------------------------------------------------------------------------
c34c93c  k8s-master01    virtualbox running  C:/multimachine/kubernetes-sandbox-remote
adb4ffe  worker01        virtualbox running  C:/multimachine/kubernetes-sandbox-remote
2e21187  worker02        virtualbox running  C:/multimachine/kubernetes-sandbox-remote
b39b49d  remotecontrol01 virtualbox running  C:/multimachine/kubernetes-sandbox-remote

vagrant ssh remotecontrol01
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/initial.yml
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/kube-dependencies.yml
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/masters.yml
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/workers.yml

vagrant ssh k8s-master01
$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master01   Ready    master   20m   v1.16.0
worker01       Ready    <none>   12m   v1.16.0
worker02       Ready    <none>   12m   v1.16.0
$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-55754f75c-kckwb   1/1     Running   0          19m
kube-system   calico-node-6qhgc                         1/1     Running   7          19m
kube-system   calico-node-8648z                         1/1     Running   0          11m
kube-system   calico-node-m4thf                         1/1     Running   0          11m
kube-system   coredns-5644d7b6d9-2844c                  1/1     Running   0          19m
kube-system   coredns-5644d7b6d9-2dwp2                  1/1     Running   0          19m
kube-system   etcd-k8s-master01                         1/1     Running   0          18m
kube-system   kube-apiserver-k8s-master01               1/1     Running   0          19m
kube-system   kube-controller-manager-k8s-master01      1/1     Running   0          18m
kube-system   kube-proxy-2cwcx                          1/1     Running   0          11m
kube-system   kube-proxy-7xbfz                          1/1     Running   0          11m
kube-system   kube-proxy-dfgxk                          1/1     Running   0          19m
kube-system   kube-scheduler-k8s-master01               1/1     Running   0          18m
~~~~
~~~~
user/password: vagrant/vagrant
vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/initial.yml
 [WARNING]: Found variable using reserved name: remote_user


PLAY [localhost] **************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Create user accounts and add users to groups] ***************************************************************************************************************************************************************
changed: [localhost] => (item=vagrant)

TASK [Copy keys] **************************************************************************************************************************************************************************************************
The authenticity of host 'k8s-master01 (192.168.50.10)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? yes
vagrant@k8s-master01's password:
changed: [localhost] => (item=k8s-master01)
The authenticity of host 'worker01 (192.168.50.11)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? yes
vagrant@worker01's password:
changed: [localhost] => (item=worker01)
The authenticity of host 'worker02 (192.168.50.12)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? yes
vagrant@worker02's password:
changed: [localhost] => (item=worker02)

PLAY RECAP ********************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

~~~~

~~~~
vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/kube-dependencies.yml

PLAY [all] ********************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [worker02]
ok: [k8s-master01]
ok: [worker01]

TASK [Remove swapfile from /etc/fstab] ****************************************************************************************************************************************************************************
ok: [k8s-master01] => (item=swap)
ok: [worker02] => (item=swap)
ok: [worker01] => (item=swap)
changed: [k8s-master01] => (item=none)
changed: [worker02] => (item=none)
changed: [worker01] => (item=none)

TASK [Disable swap] ***********************************************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker02]
changed: [worker01]

TASK [APT: Install aptitude package] ******************************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker01]
changed: [worker02]

TASK [Install packages that allow apt to be used over HTTPS] ******************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker01]
changed: [worker02]

TASK [Add an apt signing key for Docker] **************************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker02]
changed: [worker01]

TASK [Add apt repository for stable version] **********************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker02]
changed: [worker01]

TASK [Install docker and its dependecies] *************************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker01]
changed: [worker02]

TASK [install APT Transport HTTPS] ********************************************************************************************************************************************************************************
ok: [k8s-master01]
ok: [worker02]
ok: [worker01]

TASK [add Kubernetes apt-key] *************************************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker02]
changed: [worker01]

TASK [add Kubernetes' APT repository] *****************************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker02]
changed: [worker01]

TASK [Install Kubernetes binaries] ********************************************************************************************************************************************************************************
changed: [k8s-master01]
changed: [worker02]
changed: [worker01]

PLAY [masters] ****************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [k8s-master01]

TASK [Install Kubernetes binaries] ********************************************************************************************************************************************************************************
ok: [k8s-master01]

PLAY RECAP ********************************************************************************************************************************************************************************************************
k8s-master01               : ok=14   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker01                   : ok=12   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker02                   : ok=12   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
~~~~

~~~~
vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/masters.yml                                           t/kube-cluster/hosts /vagrant/kube-cluster/initial.yml

PLAY [masters] ****************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [k8s-master01]

TASK [Remove swapfile from /etc/fstab] ****************************************************************************************************************************************************************************
ok: [k8s-master01] => (item=swap)
ok: [k8s-master01] => (item=none)

TASK [Disable swap] ***********************************************************************************************************************************************************************************************
changed: [k8s-master01]

TASK [initialize the cluster] *************************************************************************************************************************************************************************************
changed: [k8s-master01]

TASK [create .kube directory] *************************************************************************************************************************************************************************************
changed: [k8s-master01]

TASK [copy admin.conf to user's kube config] **********************************************************************************************************************************************************************
changed: [k8s-master01]

TASK [install Pod network] ****************************************************************************************************************************************************************************************
changed: [k8s-master01]

PLAY RECAP ********************************************************************************************************************************************************************************************************
k8s-master01               : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
~~~~

~~~~
vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/workers.yml

PLAY [masters] ****************************************************************************************************************************************************************************************************

TASK [get join command] *******************************************************************************************************************************************************************************************
changed: [k8s-master01]

TASK [set join command] *******************************************************************************************************************************************************************************************
ok: [k8s-master01]

PLAY [workers] ****************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [worker01]
ok: [worker02]

TASK [join cluster] ***********************************************************************************************************************************************************************************************
changed: [worker02]
changed: [worker01]

PLAY RECAP ********************************************************************************************************************************************************************************************************
k8s-master01               : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker01                   : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker02                   : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
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
vagrant@k8s-master01:~$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master01   Ready    master   14m   v1.15.2
worker01       Ready    <none>   11m   v1.15.2
worker02       Ready    <none>   11m   v1.15.2
vagrant@k8s-master01:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-5df986d44c-c6gwx   1/1     Running   0          5m38s
kube-system   calico-node-cfjfk                          1/1     Running   1          5m37s
kube-system   calico-node-kdqlh                          1/1     Running   0          3m54s
kube-system   calico-node-x84gg                          1/1     Running   0          4m7s
kube-system   coredns-5c98db65d4-2gqpk                   1/1     Running   0          5m37s
kube-system   coredns-5c98db65d4-j6kpd                   1/1     Running   0          5m37s
kube-system   etcd-k8s-master01                          1/1     Running   0          4m55s
kube-system   kube-apiserver-k8s-master01                1/1     Running   0          5m3s
kube-system   kube-controller-manager-k8s-master01       1/1     Running   0          5m
kube-system   kube-proxy-mxqvt                           1/1     Running   0          5m37s
kube-system   kube-proxy-rl45d                           1/1     Running   0          4m7s
kube-system   kube-proxy-s7ks9                           1/1     Running   0          3m54s
kube-system   kube-scheduler-k8s-master01                1/1     Running   0          5m9s
~~~~



Controlling your cluster from machines other than the control-plane node
~~~~
vagrant@k8s-master01:~$ hostnamectl | grep "Operating System"
  Operating System: Ubuntu 19.04
vagrant@worker01:~$ hostnamectl | grep "Operating System"
    Operating System: Ubuntu 16.04.5 LTS
vagrant@worker02:~$ hostnamectl | grep "Operating System"
      Operating System: Ubuntu 18.10


[vagrant@remotecontrol01 ~]$ cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)


@k8s-master01:/etc/kubernetes/admin.conf .
copy the administrator kubeconfig file from your control-plane node to your workstation
scp vagrant@k8s-master01:/~admin.conf .

Install kubectl
[vagrant@remotecontrol01 ~]$ cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
[vagrant@remotecontrol01 ~]$ sudo yum install -y kubectl
[vagrant@remotecontrol01 ~]$ kubectl --kubeconfig ./admin.conf get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master01   Ready    master   38m   v1.15.2
worker01       Ready    <none>   31m   v1.15.2
worker02       Ready    <none>   30m   v1.15.2

~~~~

upgrade
~~~~
vagrant ssh remotecontrol01
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/initial.yml
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/kube-dependencies.yml
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/masters.yml
sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/workers.yml

vagrant ssh k8s-master01
$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master01   Ready    master   20m   v1.16.0
worker01       Ready    <none>   12m   v1.16.0
worker02       Ready    <none>   12m   v1.16.0
$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-55754f75c-kckwb   1/1     Running   0          19m
kube-system   calico-node-6qhgc                         1/1     Running   7          19m
kube-system   calico-node-8648z                         1/1     Running   0          11m
kube-system   calico-node-m4thf                         1/1     Running   0          11m
kube-system   coredns-5644d7b6d9-2844c                  1/1     Running   0          19m
kube-system   coredns-5644d7b6d9-2dwp2                  1/1     Running   0          19m
kube-system   etcd-k8s-master01                         1/1     Running   0          18m
kube-system   kube-apiserver-k8s-master01               1/1     Running   0          19m
kube-system   kube-controller-manager-k8s-master01      1/1     Running   0          18m
kube-system   kube-proxy-2cwcx                          1/1     Running   0          11m
kube-system   kube-proxy-7xbfz                          1/1     Running   0          11m
kube-system   kube-proxy-dfgxk                          1/1     Running   0          19m
kube-system   kube-scheduler-k8s-master01               1/1     Running   0          18m

$ apt-cache madison docker-ce
 docker-ce | 5:19.03.4~3-0~ubuntu-xenial
$ apt-cache madison kubelet | more
 kubelet |  1.16.2-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages


kube-dependencies.yml
# kubernetes_version : "=1.15.2-00"
kubernetes_version : "=1.16.0-00"
validated_dockerv: "=5:18.09.8~3-0~ubuntu-xenial"


Installing a pod network add-on
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

$ kubectl get pods -n kube-system
$ kubectl -n kube-system logs coredns-5644d7b6d9-cw9bg
~~~~
Init Containers
~~~~
vagrant@k8s-master:~$ kubectl apply -f /vagrant/myapp.yaml
pod/myapp-pod created

vagrant@k8s-master:~$ kubectl get -f /vagrant/myapp.yaml
NAME        READY   STATUS     RESTARTS   AGE
myapp-pod   0/1     Init:0/2   0          12m

# for more details
vagrant@k8s-master:~$ kubectl describe -f /vagrant/myapp.yaml
# Inspect the first init container
vagrant@k8s-master:~$ kubectl logs myapp-pod -c init-myservice
# Inspect the second init container
vagrant@k8s-master:~$ kubectl logs myapp-pod -c init-mydb


vagrant@k8s-master01:~$ kubectl apply -f /vagrant/services.yaml
service/myservice created
service/mydb created
vagrant@k8s-master01:~$ kubectl get -f /vagrant/myapp.yaml
NAME        READY   STATUS    RESTARTS   AGE
myapp-pod   1/1     Running   0          5m52s
vagrant@k8s-master01:~$ kubectl logs myapp-pod -c init-mydb
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      mydb
Address 1: 10.96.186.168 mydb.default.svc.cluster.local
vagrant@k8s-master01:~$ kubectl logs myapp-pod -c init-myservice | more
nslookup: can't resolve 'myservice'
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local


Init Containers
https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
~~~~
