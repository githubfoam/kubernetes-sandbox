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
smoke test hello world
~~~~

vagrant@remotecontrol01:~$ cat /vagrant/kubernetes-tutorial-4/load-balancer-example.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: load-balancer-example
  name: hello-world
spec:
  # replicas: 5
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: load-balancer-example
  template:
    metadata:
      labels:
        app.kubernetes.io/name: load-balancer-example
    spec:
      containers:
      - image: gcr.io/google-samples/node-hello:1.0
        name: hello-world
        ports:
        - containerPort: 8080

        vagrant@remotecontrol01:~$ kubectl create -f /vagrant/kubernetes-tutorial-4/load-balancer-example.yaml
        deployment.apps/hello-world created

        vagrant@remotecontrol01:~$ kubectl get deployments hello-world
        NAME          READY   UP-TO-DATE   AVAILABLE   AGE
        hello-world   0/1     1            0           13s

        vagrant@remotecontrol01:~$ kubectl describe deployments hello-world
        Name:                   hello-world
        Namespace:              default
        CreationTimestamp:      Tue, 27 Aug 2019 17:58:03 +0000
        Labels:                 app.kubernetes.io/name=load-balancer-example
        Annotations:            deployment.kubernetes.io/revision: 1
        Selector:               app.kubernetes.io/name=load-balancer-example
        Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
        StrategyType:           RollingUpdate
        MinReadySeconds:        0
        RollingUpdateStrategy:  25% max unavailable, 25% max surge
        Pod Template:
          Labels:  app.kubernetes.io/name=load-balancer-example
          Containers:
           hello-world:
            Image:        gcr.io/google-samples/node-hello:1.0
            Port:         8080/TCP
            Host Port:    0/TCP
            Environment:  <none>
            Mounts:       <none>
          Volumes:        <none>
        Conditions:
          Type           Status  Reason
          ----           ------  ------
          Available      True    MinimumReplicasAvailable
          Progressing    True    NewReplicaSetAvailable
        OldReplicaSets:  <none>
        NewReplicaSet:   hello-world-bbbb4c85d (1/1 replicas created)
        Events:
          Type    Reason             Age   From                   Message
          ----    ------             ----  ----                   -------
          Normal  ScalingReplicaSet  18s   deployment-controller  Scaled up replica set hello-world-bbbb4c85d to 1

        vagrant@remotecontrol01:~$ kubectl get replicasets
        NAME                    DESIRED   CURRENT   READY   AGE
        hello-world-bbbb4c85d   1         1         1       23s
        vagrant@remotecontrol01:~$ kubectl describe replicasets
        Name:           hello-world-bbbb4c85d
        Namespace:      default
        Selector:       app.kubernetes.io/name=load-balancer-example,pod-template-hash=bbbb4c85d
        Labels:         app.kubernetes.io/name=load-balancer-example
                        pod-template-hash=bbbb4c85d
        Annotations:    deployment.kubernetes.io/desired-replicas: 1
                        deployment.kubernetes.io/max-replicas: 2
                        deployment.kubernetes.io/revision: 1
        Controlled By:  Deployment/hello-world
        Replicas:       1 current / 1 desired
        Pods Status:    1 Running / 0 Waiting / 0 Succeeded / 0 Failed
        Pod Template:
          Labels:  app.kubernetes.io/name=load-balancer-example
                   pod-template-hash=bbbb4c85d
          Containers:
           hello-world:
            Image:        gcr.io/google-samples/node-hello:1.0
            Port:         8080/TCP
            Host Port:    0/TCP
            Environment:  <none>
            Mounts:       <none>
          Volumes:        <none>
        Events:
          Type    Reason            Age   From                   Message
          ----    ------            ----  ----                   -------
          Normal  SuccessfulCreate  28s   replicaset-controller  Created pod: hello-world-bbbb4c85d-fgctl

        vagrant@remotecontrol01:~$ kubectl get pods --selector="app.kubernetes.io/name=load-balancer-example" --output=wide
        NAME                          READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
        hello-world-bbbb4c85d-fgctl   1/1     Running   0          45s   192.168.1.22   worker02   <none>           <none>

        vagrant@remotecontrol01:~$ kubectl expose deployment hello-world --type=NodePort --name=example-service
        service/example-service exposed
        vagrant@remotecontrol01:~$ kubectl describe services example-service
        Name:                     example-service
        Namespace:                default
        Labels:                   app.kubernetes.io/name=load-balancer-example
        Annotations:              <none>
        Selector:                 app.kubernetes.io/name=load-balancer-example
        Type:                     NodePort
        IP:                       10.100.140.243
        Port:                     <unset>  8080/TCP
        TargetPort:               8080/TCP
        NodePort:                 <unset>  31744/TCP
        Endpoints:                192.168.1.22:8080
        Session Affinity:         None
        External Traffic Policy:  Cluster
        Events:                   <none>

        vagrant@remotecontrol01:~$ kubectl describe node | grep InternalIP
          InternalIP:  192.168.50.10
          InternalIP:  192.168.50.11
          InternalIP:  192.168.50.12

        vagrant@remotecontrol01:~$ kubectl get pods -n default -o wide
        NAME                          READY   STATUS    RESTARTS   AGE     IP             NODE       NOMINATED NODE   READINESS GATES
        hello-world-bbbb4c85d-fgctl   1/1     Running   0          2m54s   192.168.1.22   worker02   <none>           <none>

        vagrant@remotecontrol01:~$ kubectl describe pod hello-world-bbbb4c85d-fgctl | grep "Node:"
        Node:           worker02/192.168.50.12

        vagrant@remotecontrol01:~$ curl http://192.168.50.12:31744
        Hello Kubernetes!

        Browse http://192.168.50.12:31744



        vagrant@remotecontrol01:~$ kubectl delete services example-service
        service "example-service" deleted

        vagrant@remotecontrol01:~$ kubectl delete deployment hello-world
        deployment.extensions "hello-world" deleted

~~~~
smoke test jenkins
~~~~
vagrant@remotecontrol01:~$ kubectl create -f /vagrant/kubernetes-tutorial-6/jenkins-deployment.yaml --namespace=jenkins
deployment.extensions/jenkins-deployment created
service/jenkins-svc created

vagrant@remotecontrol01:~$ kubectl get deployments  --all-namespaces -o wide
NAMESPACE     NAME                 READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                     SELECTOR
jenkins       jenkins-deployment   0/1     1            0           3s    jenkins      jenkins:2.60.3             app=jenkins

vagrant@remotecontrol01:~$ kubectl delete -f /vagrant/kubernetes-tutorial-6/jenkins-deployment.yaml --namespace=jenkins
deployment.extensions "jenkins-deployment" deleted
service "nginx-svc" deleted

vagrant@remotecontrol01:~$ kubectl  describe deployments --namespace=jenkins
Name:                   jenkins-deployment
Namespace:              jenkins
CreationTimestamp:      Tue, 27 Aug 2019 18:21:34 +0000
Labels:                 app=jenkins
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=jenkins
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=jenkins
  Containers:
   jenkins:
    Image:        jenkins:2.60.3
    Port:         8080/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   jenkins-deployment-868cc579df (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  28s   deployment-controller  Scaled up replica set jenkins-deployment-868cc579df to 1


  vagrant@remotecontrol01:~$ kubectl create -f /vagrant/kubernetes-tutorial-6/jenkins-service.yaml --namespace=jenkins
  service/jenkins created

  vagrant@remotecontrol01:~$ kubectl get pods -n jenkins
  NAME                                  READY   STATUS    RESTARTS   AGE
  jenkins-deployment-868cc579df-mv8k8   1/1     Running   0          9m24s

  vagrant@remotecontrol01:~$ kubectl describe pod jenkins-deployment-868cc579df-mv8k8 -n jenkins | grep "Node:"
Node:           worker01/192.168.50.11

vagrant@remotecontrol01:~$ kubectl get services -n jenkins
NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
jenkins   NodePort   10.108.24.206   <none>        8080:30000/TCP   10m

vagrant@remotecontrol01:~$ kubectl describe -n jenkins services jenkins
Name:                     jenkins
Namespace:                jenkins
Labels:                   <none>
Annotations:              <none>
Selector:                 app=jenkins
Type:                     NodePort
IP:                       10.108.24.206
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30000/TCP
Endpoints:                192.168.2.25:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

vagrant@remotecontrol01:~$ curl http://192.168.50.11:30000
<html><head><meta http-equiv='refresh' content='1;url=/login?from=%2F'/><script>window.location.replace('/login?from=%2F');</script></head><body style='background-color:white; color:white;'>


Authentication required
<!--
You are authenticated as: anonymous
Groups that you are in:

Permission you need to have (but didn't): hudson.model.Hudson.Administer
-->

</body></html>

vagrant@remotecontrol01:~$ kubectl logs -n jenkins jenkins-deployment-868cc579df-mv8k8
*************************************************************
*************************************************************
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

86f13cf78d6841688d689dc3987230f4

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
*************************************************************
*************************************************************


Browse
http://192.168.50.11:30000

# get the password within the pod.
vagrant@remotecontrol01:~$ kubectl exec -it jenkins-deployment-868cc579df-mv8k8 bash
Error from server (NotFound): pods "jenkins-deployment-868cc579df-mv8k8" not found

vagrant@remotecontrol01:~$ kubectl exec -it jenkins-deployment-868cc579df-mv8k8 -n jenkins bash
jenkins@jenkins-deployment-868cc579df-mv8k8:/$ cat /var/jenkins_home/secrets/initialAdminPassword
86f13cf78d6841688d689dc3987230f4
jenkins@jenkins-deployment-868cc579df-mv8k8:/$ exit
exit
vagrant@remotecontrol01:~$
vagrant@remotecontrol01:~$ cat /var/jenkins_home/secrets/initialAdminPassword
cat: /var/jenkins_home/secrets/initialAdminPassword: No such file or directory


vagrant@remotecontrol01:~$ kubectl get services -n jenkins
NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
jenkins   NodePort   10.108.24.206   <none>        8080:30000/TCP   17m
vagrant@remotecontrol01:~$ kubectl delete services example-service
service "example-service" deleted


vagrant@remotecontrol01:~$ kubectl get deployment -n jenkins
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
jenkins-deployment   1/1     1            1           18m
vagrant@remotecontrol01:~$ kubectl delete deployment -n jenkins jenkins-deployment
deployment.extensions "jenkins-deployment" deleted

~~~~
smoke test jenkins + ingress
~~~~
vagrant@remotecontrol01:~$ cat /vagrant/jenkins-ingress/jenkins-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: jenkins-master
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: jenkins-master
    spec:
      containers:
       - name: jenkins-leader
         image: jenkins
         volumeMounts:
          - name: jenkins-home
            mountPath: /var/jenkins_home
          - name: docker-sock-volume
            mountPath: /var/run/docker.sock
         resources:
           requests:
             memory: "1024Mi"
             cpu: "0.5"
           limits:
             memory: "1024Mi"
             cpu: "0.5"
         ports:
           - name: http-port
             containerPort: 8080
           - name: jnlp-port
             containerPort: 50000
      volumes:
       - name: jenkins-home
         emptyDir: {}
       - name: docker-sock-volume
         hostPath:
           path: /var/run/docker.sock
vagrant@remotecontrol01:~$ kubectl create -f /vagrant/jenkins-ingress/jenkins-deploy.yaml
deployment.extensions/jenkins-master created

vagrant@remotecontrol01:~$ cat /vagrant/jenkins-ingress/jenkins-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins-master-svc
  labels:
    app: jenkins-master
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  - port: 50000
    targetPort: 50000
    protocol: TCP
    name: slave
  selector:
    app: jenkins-master
vagrant@remotecontrol01:~$ kubectl create -f /vagrant/jenkins-ingress/jenkins-svc.yaml
service/jenkins-master-svc created


vagrant@remotecontrol01:~$ kubectl delete services jenkins-master-svc
service "jenkins-master-svc" deleted
vagrant@remotecontrol01:~$ kubectl delete deployment jenkins-master
deployment.extensions "jenkins-master" deleted

vagrant@remotecontrol01:~$ kubectl get deployment -o wide --watch
NAME             READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS       IMAGES    SELECTOR
jenkins-master   0/1     1            0           2m34s   jenkins-leader   jenkins   app=jenkins-master
jenkins-master   1/1     1            1           2m40s   jenkins-leader   jenkins   app=jenkins-master


~~~~
