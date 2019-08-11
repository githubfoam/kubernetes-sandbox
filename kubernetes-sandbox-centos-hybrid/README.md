# kubernetes sandbox

~~~~
cross platform (freebsd,lin,win,mac..etc)
~~~~

~~~~
make sure the docker-ce and kubernetes are using same 'cgroup'.

$ sudo docker info | grep -i cgroup
Cgroup Driver: cgroupfs
~~~~

~~~~
[vagrant@k8s-master ~]$ sudo yum --showduplicates list docker-ce | grep 18.09.*
docker-ce.x86_64            3:18.09.8-3.el7                    @docker-ce-stable
docker-ce.x86_64            3:18.09.0-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.1-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.2-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.3-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.4-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.5-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.6-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.7-3.el7                    docker-ce-stable
docker-ce.x86_64            3:18.09.8-3.el7                    docker-ce-stable
[vagrant@k8s-master ~]$ sudo yum --showduplicates list docker-ce-cli | grep 18.09.*
docker-ce-cli.x86_64              1:18.09.8-3.el7              @docker-ce-stable
docker-ce-cli.x86_64              1:18.09.0-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.1-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.2-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.3-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.4-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.5-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.6-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.7-3.el7              docker-ce-stable
docker-ce-cli.x86_64              1:18.09.8-3.el7              docker-ce-stable

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
vagrant up node01
vagrant up node02
~~~~
hybrid-cluster
~~~~
[vagrant@k8s-master ~]$ cat /etc/centos-release
CentOS Linux release 7.6.1810 (Core)
[vagrant@node01 ~]$ cat /etc/centos-release
CentOS Linux release 7.4.1708 (Core)
[vagrant@node02 ~]$ cat /etc/centos-release
CentOS Linux release 7.5.1804 (Core)
~~~~

~~~~

vagrant ssh k8s-master
[vagrant@k8s-master ~]$ kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   20m   v1.15.2
node01       Ready    <none>   11m   v1.15.2
~~~~
node-2 added after cluster booted
~~~~
[vagrant@k8s-master ~]$ kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k8s-master   Ready    master   34m     v1.15.2
node01       Ready    <none>   24m     v1.15.2
node02       Ready    <none>   2m19s   v1.15.2
~~~~
