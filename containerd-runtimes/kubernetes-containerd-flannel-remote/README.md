# kubernetes sandbox with containerd runtimes flannel

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
~~~~
~~~~
vagrant up

vagrant ssh vagrant-remotecontrol02

(sudo runs)

$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts /vagrant/kube-cluster/initial.yml
$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts  /vagrant/kube-cluster/01_masters.yml
$ sudo ansible-playbook -i /vagrant/kube-cluster/hosts  /vagrant/kube-cluster/02_workers.yml

vagrant@vagrant-k8s-master02:~$ kubectl get nodes
NAME                   STATUS   ROLES    AGE     VERSION
vagrant-k8s-master02   Ready    master   3m46s   v1.15.2
vagrant-worker03       Ready    <none>   109s    v1.15.2
vagrant-worker04       Ready    <none>   109s    v1.15.2

vagrant@vagrant-k8s-master02:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                           READY   STATUS    RESTARTS   AGE
kube-system   coredns-5c98db65d4-4vkwr                       1/1     Running   0          4m11s
kube-system   coredns-5c98db65d4-xj429                       1/1     Running   0          4m11s
kube-system   etcd-vagrant-k8s-master02                      1/1     Running   0          3m32s
kube-system   kube-apiserver-vagrant-k8s-master02            1/1     Running   0          3m56s
kube-system   kube-controller-manager-vagrant-k8s-master02   1/1     Running   0          3m56s
kube-system   kube-flannel-ds-amd64-7lkdl                    1/1     Running   0          2m38s
kube-system   kube-flannel-ds-amd64-jrg56                    1/1     Running   0          2m37s
kube-system   kube-flannel-ds-amd64-vdb7s                    1/1     Running   0          4m11s
kube-system   kube-proxy-9sjc8                               1/1     Running   0          2m37s
kube-system   kube-proxy-d646k                               1/1     Running   0          4m11s
kube-system   kube-proxy-v7qbw                               1/1     Running   0          2m38s
kube-system   kube-scheduler-vagrant-k8s-master02            1/1     Running   0          3m42s

vagrant@vagrant-k8s-master02:~$ sudo crictl images
IMAGE                                TAG                 IMAGE ID            SIZE
k8s.gcr.io/coredns                   1.3.1               eb516548c180f       12.3MB
k8s.gcr.io/etcd                      3.3.10              2c4adeb21b4ff       76.2MB
k8s.gcr.io/kube-apiserver            v1.15.2             34a53be6c9a7e       49.3MB
k8s.gcr.io/kube-controller-manager   v1.15.2             9f5df470155d4       47.8MB
k8s.gcr.io/kube-proxy                v1.15.2             167bbf6c93388       30.1MB
k8s.gcr.io/kube-scheduler            v1.15.2             88fa9cb27bd2d       29.9MB
k8s.gcr.io/pause                     3.1                 da86e6ba6ca19       317kB
quay.io/coreos/flannel               v0.11.0-amd64       8a9c4ced3ff92       16.9MB

~~~~

~~~~
# TODO This needs to be removed once we have consistent concurrent pull results
- name: "Pre-pull pause container image"
  shell: |
    /usr/local/bin/ctr pull k8s.gcr.io/pause:3.1
    /usr/local/bin/crictl --runtime-endpoint unix:///run/containerd/containerd.sock \
    pull k8s.gcr.io/pause:3.1


    vagrant@vagrant-k8s-master02:~$ sudo systemctl status containerd
    ● containerd.service - containerd container runtime
       Loaded: loaded (/etc/systemd/system/containerd.service; enabled; vendor preset: enabled)
       Active: active (running) since Wed 2019-08-14 17:34:41 UTC; 22min ago
         Docs: https://containerd.io
     Main PID: 23407 (containerd)
        Tasks: 206
       Memory: 153.2M
          CPU: 33.768s
       CGroup: /system.slice/containerd.service
               ├─23407 /usr/local/bin/containerd
               ├─24961 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/c3e37382640846f9d734ab6ad710cadf7c484e4217d967254b90425400f08092 -address /run/containerd/c
               ├─24965 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/1be3a50257c1606080882e8330c828d9d7ffcf2aae0a4b0f9991431a492e7d0a -address /run/containerd/c
               ├─24970 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/bc705b91a474cbba986c25de664e618e1f9a98bc1da7039611ff5a5e9ecd80da -address /run/containerd/c
               ├─24971 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/88ba4ab2df81839f5229e1d98292d5e5903603751f608ec09a266a33a1f8ecf4 -address /run/containerd/c
               ├─25254 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/142e8fb8ae7543b51896962092e0985defb8feb8121025c473df90449bec3bb0 -address /run/containerd/c
               ├─25262 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/6285c5b457c5364cce216eacffc6793e99aeb3542380f9e89ca13e8476ae24ce -address /run/containerd/c
               ├─25276 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/2b25743ca6224b9727565b3d2d3e55e04265e43dd2519679ce9441b50ae77571 -address /run/containerd/c
               ├─25280 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/f42ae19a88fde06434ea0883dd2322b8bff472af2b1324e90f12cdc03b0df660 -address /run/containerd/c
               ├─25969 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/6e3013e0fd73dff5a8955fc450bed7349bf68b12328201db8bd3da298277110f -address /run/containerd/c
               ├─25977 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/d6455735b3a028a9d46e6664c9c092c4562dc4c7bc9bde39f14cebdb7e98620f -address /run/containerd/c
               ├─26138 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/3ea13855d40e80a2d81818536646d47f82c85a286873dbd0a03588592ce31478 -address /run/containerd/c
               ├─26525 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/c8e8105a3a625e9fac0f13d44cc934aa6209c433ea9e50f0e625f9db393bf5de -address /run/containerd/c
               ├─26853 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/585cff44621c0b09420585b45f44d022a0e2d8e845ff736feb52fd98300f844a -address /run/containerd/c
               ├─26923 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/282bf30a41dbfada3e113fffbbe4b3d6c4bc098da419a5c3cab8aea8bc7c8355 -address /run/containerd/c
               ├─27036 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/339a68e52a0778a4bc825eeebc5d281ce50428b68a2acb6316ecba09c31fb446 -address /run/containerd/c
               └─27122 containerd-shim -namespace k8s.io -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/k8s.io/a78eee5c1937ea4f71e4e3779c0ac3fdfe90f28b0795da2536524cc381dea42f -address /run/containerd/c

    Aug 14 17:57:06 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:06.898649220Z" level=info msg="ExecSync for "6285c5b457c5364cce216eacffc6793e99aeb3542380f9e89ca13e8476ae24ce" with command [/bin/sh
    Aug 14 17:57:07 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:07.033027343Z" level=info msg="Finish piping "stderr" of container exec "e59e0c3e0a15c4959c0ada28686f929416ee158281bbcf26e33bc326381
    Aug 14 17:57:07 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:07.033405290Z" level=info msg="Finish piping "stdout" of container exec "e59e0c3e0a15c4959c0ada28686f929416ee158281bbcf26e33bc326381
    Aug 14 17:57:07 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:07.034277551Z" level=info msg="Exec process "e59e0c3e0a15c4959c0ada28686f929416ee158281bbcf26e33bc32638121ea1" exits with exit code
    Aug 14 17:57:07 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:07.102656146Z" level=info msg="ExecSync for "6285c5b457c5364cce216eacffc6793e99aeb3542380f9e89ca13e8476ae24ce" returns with exit cod
    Aug 14 17:57:16 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:16.898839406Z" level=info msg="ExecSync for "6285c5b457c5364cce216eacffc6793e99aeb3542380f9e89ca13e8476ae24ce" with command [/bin/sh
    Aug 14 17:57:17 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:17.033476230Z" level=info msg="Finish piping "stderr" of container exec "d08093cf5117b879a1bce123687da6a2e8fa624cff267f95cc500301a38
    Aug 14 17:57:17 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:17.033564171Z" level=info msg="Finish piping "stdout" of container exec "d08093cf5117b879a1bce123687da6a2e8fa624cff267f95cc500301a38
    Aug 14 17:57:17 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:17.034214861Z" level=info msg="Exec process "d08093cf5117b879a1bce123687da6a2e8fa624cff267f95cc500301a387d134" exits with exit code
    Aug 14 17:57:17 vagrant-k8s-master02 containerd[23407]: time="2019-08-14T17:57:17.112042881Z" level=info msg="ExecSync for "6285c5b457c5364cce216eacffc6793e99aeb3542380f9e89ca13e8476ae24ce" returns with exit cod
    lines 1-37/37 (END)


~~~~
~~~~
vagrant@vagrant-k8s-master02:~$ kubectl run nginx --image=nginx
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/nginx created

vagrant@vagrant-k8s-master02:~$ kubectl get pods -l run=nginx
NAME                     READY   STATUS    RESTARTS   AGE
nginx-7bb7cd8db5-lqmp9   1/1     Running   0          86s


vagrant@vagrant-k8s-master02:~$ POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")
vagrant@vagrant-k8s-master02:~$ echo $POD_NAME
nginx-7bb7cd8db5-lqmp9

vagrant@vagrant-k8s-master02:~$ kubectl port-forward $POD_NAME 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080

In a new terminal make an HTTP request using the forwarding address
vagrant@vagrant-k8s-master02:~$ curl --head http://127.0.0.1:8080
HTTP/1.1 200 OK
Server: nginx/1.17.2
Date: Wed, 14 Aug 2019 18:05:15 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 23 Jul 2019 11:45:37 GMT
Connection: keep-alive
ETag: "5d36f361-264"
Accept-Ranges: bytes


the previous terminal and stop the port forwarding to the nginx pod
vagrant@vagrant-k8s-master02:~$ kubectl logs $POD_NAME
127.0.0.1 - - [14/Aug/2019:18:05:15 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/7.47.0" "-"

execute commands in a container.
vagrant@vagrant-k8s-master02:~$ kubectl exec -ti $POD_NAME -- nginx -v
nginx version: nginx/1.17.2

Expose the nginx deployment using a NodePort service
vagrant@vagrant-k8s-master02:~$ kubectl expose deployment nginx --port 80 --type NodePort
service/nginx exposed

Retrieve the node port assigned to the nginx service
vagrant@vagrant-k8s-master02:~$ NODE_PORT=$(kubectl get svc nginx \
>   --output=jsonpath='{range .spec.ports[0]}{.nodePort}')
vagrant@vagrant-k8s-master02:~$ echo $NODE_PORT
31859

$ kubectl -n default get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-7bb7cd8db5-lqmp9   1/1     Running   0          14m
vagrant@vagrant-k8s-master02:~$ kubectl -n default describe pod nginx-7bb7cd8db5-lqmp9


vagrant@vagrant-k8s-master02:~$ cat <<EOF | kubectl apply -f -
> apiVersion: v1
> kind: Pod
> metadata:
>   name: untrusted
>   annotations:
>     io.kubernetes.cri.untrusted-workload: "true"
> spec:
>   containers:
>     - name: webserver
>       image: gcr.io/hightowerlabs/helloworld:2.0.0
> EOF


vagrant@vagrant-k8s-master02:~$ kubectl get pods -o wide
NAME                     READY   STATUS              RESTARTS   AGE   IP           NODE               NOMINATED NODE   READINESS GATES
nginx-7bb7cd8db5-lqmp9   1/1     Running             0          19m   10.217.1.2   vagrant-worker03   <none>           <none>
untrusted                0/1     ContainerCreating   0          88s   <none>       vagrant-worker04   <none>           <none>


vagrant@vagrant-k8s-master02:~$ kubectl -n default describe pod untrusted
Name:         untrusted
Namespace:    default
Priority:     0
Node:         vagrant-worker04/10.217.50.12
Start Time:   Wed, 14 Aug 2019 18:18:14 +0000
Labels:       <none>
Annotations:  io.kubernetes.cri.untrusted-workload: true
              kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{"io.kubernetes.cri.untrusted-workload":"true"},"name":"untrusted","namespace":"...
Status:       Pending
IP:
Containers:
  webserver:
    Container ID:
    Image:          gcr.io/hightowerlabs/helloworld:2.0.0
    Image ID:
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-xk7h8 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  default-token-xk7h8:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-xk7h8
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason                  Age                 From                       Message
  ----     ------                  ----                ----                       -------
  Normal   Scheduled               107s                default-scheduler          Successfully assigned default/untrusted to vagrant-worker04
  Warning  FailedCreatePodSandBox  10s (x8 over 106s)  kubelet, vagrant-worker04  Failed create pod sandbox: rpc error: code = Unknown desc = failed to get sandbox runtime: no runtime for "untrusted" is configured

  vagrant@vagrant-k8s-master02:~$ INSTANCE_NAME=$(kubectl get pod untrusted --output=jsonpath='{.spec.nodeName}')
  vagrant@vagrant-k8s-master02:~$ echo $INSTANCE_NAME
  vagrant-worker04

  Smoke Test
  https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/13-smoke-test.md
~~~~

~~~~
  vagrant@vagrant-k8s-master02:~$ sudo crictl ps
CONTAINER ID        IMAGE               CREATED             STATE               NAME                      ATTEMPT             POD ID
a78eee5c1937e       eb516548c180f       31 minutes ago      Running             coredns                   0                   339a68e52a077
282bf30a41dbf       eb516548c180f       31 minutes ago      Running             coredns                   0                   585cff44621c0
c8e8105a3a625       8a9c4ced3ff92       31 minutes ago      Running             kube-flannel              0                   d6455735b3a02
3ea13855d40e8       167bbf6c93388       31 minutes ago      Running             kube-proxy                0                   6e3013e0fd73d
f42ae19a88fde       34a53be6c9a7e       32 minutes ago      Running             kube-apiserver            0                   bc705b91a474c
2b25743ca6224       9f5df470155d4       32 minutes ago      Running             kube-controller-manager   0                   1be3a50257c16
6285c5b457c53       2c4adeb21b4ff       32 minutes ago      Running             etcd                      0                   c3e3738264084
142e8fb8ae754       88fa9cb27bd2d       32 minutes ago      Running             kube-scheduler            0                   88ba4ab2df818

vagrant@vagrant-k8s-master02:~$ sudo crictl pods
POD ID              CREATED             STATE               NAME                                           NAMESPACE           ATTEMPT
339a68e52a077       31 minutes ago      Ready               coredns-5c98db65d4-jqf9z                       kube-system         0
585cff44621c0       31 minutes ago      Ready               coredns-5c98db65d4-8wczx                       kube-system         0
d6455735b3a02       32 minutes ago      Ready               kube-flannel-ds-amd64-hhr7m                    kube-system         0
6e3013e0fd73d       32 minutes ago      Ready               kube-proxy-5944d                               kube-system         0
88ba4ab2df818       32 minutes ago      Ready               kube-scheduler-vagrant-k8s-master02            kube-system         0
bc705b91a474c       32 minutes ago      Ready               kube-apiserver-vagrant-k8s-master02            kube-system         0
1be3a50257c16       32 minutes ago      Ready               kube-controller-manager-vagrant-k8s-master02   kube-system         0
c3e3738264084       32 minutes ago      Ready               etcd-vagrant-k8s-master02                      kube-system         0
vagrant@vagrant-k8s-master02:~$ sudo crictl stats
CONTAINER           CPU %               MEM                 DISK                INODES
142e8fb8ae754       0.14                17.84MB             12.29kB             4
282bf30a41dbf       0.59                16.67MB             45.06kB             14
2b25743ca6224       1.30                54.49MB             73.73kB             19
3ea13855d40e8       0.04                21.11MB             40.96kB             11
6285c5b457c53       1.70                52.22MB             40.96kB             13
a78eee5c1937e       0.52                11.71MB             45.06kB             14
c8e8105a3a625       0.00                9.65MB              32.77kB             10
f42ae19a88fde       2.57                209.9MB             53.25kB             13

~~~~

~~~~
Containerd
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd

https://containerd.io/

https://github.com/coreos/flannel
~~~~
