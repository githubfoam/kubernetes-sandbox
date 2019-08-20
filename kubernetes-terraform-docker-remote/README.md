# kubernetes terraform docker runtimes sandbox

cross platform(freebsd,lin,win,mac..etc)

~~~~


vagrant global-status
id       name            provider   state    directory
-----------------------------------------------------------------------------------------------------------
c34c93c  k8s-master01    virtualbox running  C:/multimachine/kubernetes-sandbox-remote
adb4ffe  worker01        virtualbox running  C:/multimachine/kubernetes-sandbox-remote
2e21187  worker02        virtualbox running  C:/multimachine/kubernetes-sandbox-remote
b39b49d  remotecontrol01 virtualbox running  C:/multimachine/kubernetes-sandbox-remote

vagrant ssh remotecontrol01

vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/initial.yml

vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/kube-dependencies.yml

vagrant@remotecontrol01:~$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/masters.yml  

[vagrant@remotecontrol01 ~]$ sudo ansible-inventory --inventory-file=/vagrant/kube-cluster/hosts --graph
@all:
  |--@masters:
  |  |--k8s-master01
  |--@ungrouped:
  |--@workers:
  |  |--worker01
  |  |--worker02
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
[vagrant@remotecontrol01 ~]$ sudo ansible-inventory --inventory-file=/vagrant/kube-cluster/hosts --graph
@all:
  |--@masters:
  |  |--k8s-master01
  |--@ungrouped:
  |--@workers:
  |  |--worker01
  |  |--worker02

vagrant@k8s-master01:~$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k8s-master01   Ready    master   14m   v1.15.2
worker01       Ready    <none>   11m   v1.15.2
worker02       Ready    <none>   11m   v1.15.2

[vagrant@remotecontrol01 ~]$ sudo ansible -i /vagrant/kube-cluster/hosts k8s-master01 -m shell -a "kubectl get pods --all-namespaces"
k8s-master01 | CHANGED | rc=0 >>
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
kube-system   coredns-5c98db65d4-6qsrl               1/1     Running   0          12m
kube-system   coredns-5c98db65d4-ldzj8               1/1     Running   0          12m
kube-system   etcd-k8s-master01                      1/1     Running   0          12m
kube-system   kube-apiserver-k8s-master01            1/1     Running   0          12m
kube-system   kube-controller-manager-k8s-master01   1/1     Running   0          12m
kube-system   kube-flannel-ds-amd64-7jv62            1/1     Running   0          6m48s
kube-system   kube-flannel-ds-amd64-j7xsf            1/1     Running   0          12m
kube-system   kube-flannel-ds-amd64-jhqlz            1/1     Running   0          6m41s
kube-system   kube-proxy-4gq2g                       1/1     Running   0          6m41s
kube-system   kube-proxy-nfn7s                       1/1     Running   0          6m48s
kube-system   kube-proxy-ng2bc                       1/1     Running   0          12m
kube-system   kube-scheduler-k8s-master01            1/1     Running   0          12m

[vagrant@remotecontrol01 ~]$ sudo ansible -i /vagrant/kube-cluster/hosts k8s-master01 -m shell -a "wget -q -nc https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip"
 [WARNING]: Consider using the get_url or uri module rather than running 'wget'.  If you need to use command because get_url or uri is insufficient you can add 'warn: false' to this command task or set
'command_warnings=False' in ansible.cfg to get rid of this message.

k8s-master01 | CHANGED | rc=0 >>


[vagrant@remotecontrol01 ~]$ sudo ansible -i /vagrant/kube-cluster/hosts k8s-master01 -m shell -a "unzip terraform_0.12.6_linux_amd64.zip"                 . 6/terraform_0.12.6_linux_amd64.zip"
 [WARNING]: Consider using the unarchive module rather than running 'unzip'.  If you need to use command because unarchive is insufficient you can add 'warn: false' to this command task or set
'command_warnings=False' in ansible.cfg to get rid of this message.

k8s-master01 | CHANGED | rc=0 >>
Archive:  terraform_0.12.6_linux_amd64.zip
  inflating: terraform

[vagrant@remotecontrol01 ~]$ sudo ansible -i /vagrant/kube-cluster/hosts k8s-master01 -m shell -a "sudo mv terraform /usr/local/bin/"                       .6/terraform_0.12.6_linux_amd64.zip"
 [WARNING]: Consider using 'become', 'become_method', and 'become_user' rather than running sudo

k8s-master01 | CHANGED | rc=0 >>


[vagrant@remotecontrol01 ~]$ sudo ansible -i /vagrant/kube-cluster/hosts k8s-master01 -m shell -a "terraform version"                                       .6/terraform_0.12.6_linux_amd64.zip"
k8s-master01 | CHANGED | rc=0 >>
Terraform v0.12.6

~~~~


deploy hola mundo
~~~~
vagrant@k8s-master01:~$ pwd
/home/vagrant
vagrant@k8s-master01:~$ cp -r /vagrant/holamundo_app/ .

vagrant@k8s-master01:~/$ terraform destroy -auto-approve
vagrant@k8s-master01:~/$ terraform init
vagrant@k8s-master01:~/$ terraform plan -out holamundo.tfplan
vagrant@k8s-master01:~/$ terraform apply holamundo.tfplan
vagrant@k8s-master01:~/$ terraform show

vagrant@k8s-master01:~/$ kubectl get pods
NAME           READY   STATUS    RESTARTS   AGE
echo-example   1/1     Running   0          4m19s

vagrant@k8s-master01:~/$ kubectl get services
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
echo-example   ClusterIP   10.105.53.235   <none>        80/TCP    4m41s
kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP   59m


vagrant@k8s-master01:~/$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
default       echo-example                           1/1     Running   0          5m10s
kube-system   coredns-5c98db65d4-6qsrl               1/1     Running   0          59m
kube-system   coredns-5c98db65d4-ldzj8               1/1     Running   0          59m
kube-system   etcd-k8s-master01                      1/1     Running   0          58m
kube-system   kube-apiserver-k8s-master01            1/1     Running   0          58m
kube-system   kube-controller-manager-k8s-master01   1/1     Running   0          59m
kube-system   kube-flannel-ds-amd64-7jv62            1/1     Running   0          53m
kube-system   kube-flannel-ds-amd64-j7xsf            1/1     Running   0          59m
kube-system   kube-flannel-ds-amd64-jhqlz            1/1     Running   0          53m
kube-system   kube-proxy-4gq2g                       1/1     Running   0          53m
kube-system   kube-proxy-nfn7s                       1/1     Running   0          53m
kube-system   kube-proxy-ng2bc                       1/1     Running   0          59m
kube-system   kube-scheduler-k8s-master01            1/1     Running   0          59m

~~~~
deploy nginx
~~~~
vagrant@k8s-master01:~$ pwd
/home/vagrant
vagrant@k8s-master01:~$ cp -r /vagrant/nginx_app/ .


vagrant@k8s-master01:~/$ terraform destroy -auto-approve
vagrant@k8s-master01:~/$ terraform init
vagrant@k8s-master01:~/$ terraform plan -out nginx.tfplan
vagrant@k8s-master01:~/$ terraform apply nginx.tfplan
vagrant@k8s-master01:~/$ terraform show

vagrant@k8s-master01:~/nginx_app$ kubectl get pods
NAME            READY   STATUS    RESTARTS   AGE
nginx-example   1/1     Running   0          63s
vagrant@k8s-master01:~/nginx_app$ kubectl get services
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP   67m
nginx-example   ClusterIP   10.105.164.28   <none>        80/TCP    38s

vagrant@k8s-master01:~/nginx_app$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
default       nginx-example                          1/1     Running   0          4m
kube-system   coredns-5c98db65d4-6qsrl               1/1     Running   0          69m
kube-system   coredns-5c98db65d4-ldzj8               1/1     Running   0          69m
kube-system   etcd-k8s-master01                      1/1     Running   0          69m
kube-system   kube-apiserver-k8s-master01            1/1     Running   0          69m
kube-system   kube-controller-manager-k8s-master01   1/1     Running   0          69m
kube-system   kube-flannel-ds-amd64-7jv62            1/1     Running   0          63m
kube-system   kube-flannel-ds-amd64-j7xsf            1/1     Running   0          69m
kube-system   kube-flannel-ds-amd64-jhqlz            1/1     Running   0          63m
kube-system   kube-proxy-4gq2g                       1/1     Running   0          63m
kube-system   kube-proxy-nfn7s                       1/1     Running   0          63m
kube-system   kube-proxy-ng2bc                       1/1     Running   0          69m
kube-system   kube-scheduler-k8s-master01            1/1     Running   0          69m


vagrant@k8s-master01:~/nginx_app$ terraform destroy -auto-approve
kubernetes_pod.nginx: Refreshing state... [id=default/nginx-example]
kubernetes_service.nginx: Refreshing state... [id=default/nginx-example]
kubernetes_service.nginx: Destroying... [id=default/nginx-example]
kubernetes_service.nginx: Destruction complete after 0s
kubernetes_pod.nginx: Destroying... [id=default/nginx-example]

kubernetes_pod.nginx: Still destroying... [id=default/nginx-example, 10s elapsed]
kubernetes_pod.nginx: Destruction complete after 17s

Destroy complete! Resources: 2 destroyed.

vagrant@k8s-master01:~/nginx_app$ kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   74m

vagrant@k8s-master01:~/nginx_app$ kubectl get pods
No resources found.

~~~~


vagrant shared folder issue
~~~~
$ sudo terraform destroy -auto-approve
kubernetes_pod.nginx: Refreshing state... [id=default/nginx-example]
kubernetes_service.nginx: Refreshing state... [id=default/nginx-example]

Error: fork/exec /vagrant/.terraform/plugins/linux_amd64/terraform-provider-kubernetes_v1.8.1_x4: permission denied

$ sudo lsof | grep terraform
terraform  7114  7115 terraform            root  txt       REG               0,49  47478528        188 /vagrant/app1/.terraform/plugins/linux_amd64/terraform-provider-kubernetes_v1.8.1_x4
$ sudo kill -9 711
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
