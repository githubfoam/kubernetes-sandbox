# kubernetes sandbox with containerd runtimes calico

cross platform(freebsd,lin,win,mac..etc)

~~~~
containerd_release_version: 1.2.7
ubuntu distribution_release: xenial - 16.04
kubernetes_version : 1.15.2-00
~~~~
~~~~
# local passwordless login and inventory
kubernetes-containerd-flannel-remote\inventory    

# remote passwordless login
kubernetes-containerd-flannel-remote\kube-cluster\hosts  

ROLES
- common
- containerd/

~~~~
~~~~
vagrant up

vagrant ssh vagrant-remotecontrol02

(sudo runs)

$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/initial.yml
$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts  /vagrant/kube-cluster/01_masters.yml
$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts  /vagrant/kube-cluster/02_workers.yml

vagrant ssh vagrant-k8s-master02

vagrant@vagrant-k8s-master02:~$ kubectl get nodes
NAME                   STATUS   ROLES    AGE     VERSION
vagrant-k8s-master02   Ready    master   3m46s   v1.15.2
vagrant-worker03       Ready    <none>   109s    v1.15.2
vagrant-worker04       Ready    <none>   109s    v1.15.2

vagrant@vagrant-k8s-master02:~$ sudo crictl images
IMAGE                                 TAG                 IMAGE ID            SIZE
docker.io/calico/cni                  v3.8.1              f89121d9c7646       50.1MB
docker.io/calico/kube-controllers     v3.8.1              214ddcd2a33e2       18MB
docker.io/calico/node                 v3.8.1              4fcdc789ef1ac       84.5MB
docker.io/calico/pod2daemon-flexvol   v3.8.1              6f36255ccd3f5       4.64MB
k8s.gcr.io/coredns                    1.3.1               eb516548c180f       12.3MB
k8s.gcr.io/etcd                       3.3.10              2c4adeb21b4ff       76.2MB
k8s.gcr.io/kube-apiserver             v1.15.2             34a53be6c9a7e       49.3MB
k8s.gcr.io/kube-controller-manager    v1.15.2             9f5df470155d4       47.8MB
k8s.gcr.io/kube-proxy                 v1.15.2             167bbf6c93388       30.1MB
k8s.gcr.io/kube-scheduler             v1.15.2             88fa9cb27bd2d       29.9MB
k8s.gcr.io/pause                      3.1                 da86e6ba6ca19       317kB

vagrant@vagrant-k8s-master02:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                           READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-7bd78b474d-jtf4f       1/1     Running   0          16m
kube-system   calico-node-gqjcn                              1/1     Running   0          13m
kube-system   calico-node-t2qpr                              1/1     Running   0          16m
kube-system   calico-node-v2ccp                              1/1     Running   0          13m
kube-system   coredns-5c98db65d4-mpr7n                       1/1     Running   0          16m
kube-system   coredns-5c98db65d4-rxpxr                       1/1     Running   0          16m
kube-system   etcd-vagrant-k8s-master02                      1/1     Running   0          15m
kube-system   kube-apiserver-vagrant-k8s-master02            1/1     Running   0          16m
kube-system   kube-controller-manager-vagrant-k8s-master02   1/1     Running   0          16m
kube-system   kube-proxy-6c7zb                               1/1     Running   0          13m
kube-system   kube-proxy-bhzjd                               1/1     Running   0          13m
kube-system   kube-proxy-hd5kt                               1/1     Running   0          16m
kube-system   kube-scheduler-vagrant-k8s-master02            1/1     Running   0          16m



vagrant@vagrant-k8s-master02:~$ kubectl --namespace kube-system get ds
NAME          DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
calico-node   3         3         3       3            3           beta.kubernetes.io/os=linux   17m
kube-proxy    3         3         3       3            3           beta.kubernetes.io/os=linux   17m




~~~~


runtimes
~~~~
Containerd
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd

https://containerd.io/

containerd/containerd 	The main project repo for containerd, including the container runtime
containerd/cri 	The containerd plugin for the Kubernetes Container Runtime Interface (CRI)
https://containerd.io/docs/

Kubernetes Cluster with Containerd
https://github.com/containerd/cri/tree/master/contrib/ansible
~~~~
pod network
~~~~
https://www.projectcalico.org/calico-networking-for-kubernetes/
~~~~
