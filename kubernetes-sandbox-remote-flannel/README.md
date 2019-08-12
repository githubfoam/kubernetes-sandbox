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
