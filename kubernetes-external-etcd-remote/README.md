# kubernetes sandbox with an external etcd cluster
cross platform(freebsd,lin,win,mac..etc)
~~~~
load balancer: haproxy + heartbeat
distributed reliable key-value store:etcd
container runtimes:docker
pod network:weave-net

[preflight] Running pre-flight checks
[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 18.09.8. Latest validated version: 18.06
the docker-ce-cli package was introduced in Docker CE 18.09.

subnet
192.168.0.0/16

HAProxy + heartbeat virtual IP
192.168.10.1

Etcd & HAProxy + heartbeat computes
vgetcd01 192.168.10.2 (HAProxy + heartbeat)
vgetcd02 192.168.10.3 (HAProxy + heartbeat)
vgetcd03 192.168.10.4


K8s computes
vgmaster01 192.168.10.5
vgmaster01 192.168.10.6


K8s workers
vgworker01 192.168.0.7
vgworker02 192.168.0.8
vgworker02 192.168.0.9

~~~~

~~~~
>vagrant up
>vagrant ssh vgclient01

vagrant@vgclient01:~$ sudo ansible-playbook -i /vagrant/provisioning/hosts /vagrant/provisioning/00_client01_deploy.yml

~~~~

~~~~
vagrant@vgetcd01:~$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa.
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:NioMqxbhQUg4RIyBcbNyd5TeUyWg89P8CDipyZxYcGQ vagrant@vgetcd01
The key's randomart image is:
+---[RSA 4096]----+
|%*o E .......    |
|*+ = ...  ..     |
|o.+ o.+. .       |
| = + ..=oo       |
|. + . + S.o      |
| o O + + + o     |
|  + O .   . .    |
| o   .           |
|o                |
+----[SHA256]-----+

vagrant@vgetcd01:~$ ssh-copy-id -i .ssh/id_rsa.pub vagrant@vgetcd02
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/id_rsa.pub"
The authenticity of host 'vgetcd02 (192.168.10.3)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? e^H
Please type 'yes' or 'no': yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@vgetcd02's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@vgetcd02'"
and check to make sure that only the key(s) you wanted were added.

vagrant@vgetcd01:~$ ssh vagrant@vgetcd02
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-131-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

144 packages can be updated.
91 updates are security updates.


Last login: Sun Aug 25 07:46:12 2019 from 192.168.10.13
vagrant@vgetcd02:~$ exit
logout
Connection to vgetcd02 closed.
vagrant@vgetcd01:~$



vagrant@vgetcd01:~$ ssh-copy-id -i .ssh/id_rsa.pub vagrant@vgetcd03
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/id_rsa.pub"
The authenticity of host 'vgetcd03 (192.168.10.4)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@vgetcd03's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@vgetcd03'"
and check to make sure that only the key(s) you wanted were added.

vagrant@vgetcd01:~$ ssh vagrant@vgetcd03
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-131-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

144 packages can be updated.
91 updates are security updates.


Last login: Sun Aug 25 07:47:46 2019 from 192.168.10.13
vagrant@vgetcd03:~$ exit
logout
Connection to vgetcd03 closed.
vagrant@vgetcd01:~$


vagrant@vgetcd01:~$ export HOST0=192.168.10.2
vagrant@vgetcd01:~$ export HOST1=192.168.10.3
vagrant@vgetcd01:~$ export HOST2=192.168.10.4

vagrant@vgetcd01:~$ sudo scp -r /tmp/${HOST1}/* vagrant@${HOST1}:/tmp
The authenticity of host '192.168.10.3 (192.168.10.3)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.10.3' (ECDSA) to the list of known hosts.
vagrant@192.168.10.3's password:
kubeadmcfg.yaml
peer.crt
peer.key
ca.crt
healthcheck-client.key
healthcheck-client.crt
server.crt
server.key
apiserver-etcd-client.key
apiserver-etcd-client.crt

vagrant@vgetcd01:~$ sudo ansible -i /vagrant/provisioning/hosts vgetcd02  -m shell -a "sudo cp -r /tmp/pki /etc/kubernetes/"

vagrant@vgetcd01:~$ sudo ansible -i /vagrant/provisioning/hosts vgetcd02  -m shell -a "sudo ls -lai /etc/kubernetes/pki"
 [WARNING]: Consider using 'become', 'become_method', and 'become_user' rather than running sudo

[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host vgetcd02 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will
default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in
version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
vgetcd02 | CHANGED | rc=0 >>
total 20
2361219 drwxr-xr-x 3 root root 4096 Aug 25 08:24 .
2361215 drwxr-xr-x 4 root root 4096 Aug 25 08:24 ..
2361229 -rw-r--r-- 1 root root 1090 Aug 25 08:24 apiserver-etcd-client.crt
2361228 -rw------- 1 root root 1675 Aug 25 08:24 apiserver-etcd-client.key
2361220 drwxr-xr-x 2 root root 4096 Aug 25 08:24 etcd

vagrant@vgetcd01:~$ sudo ansible -i /vagrant/provisioning/hosts vgetcd02  -m shell -a "sudo ls -lai /etc/kubernetes/pki/etcd"
 [WARNING]: Consider using 'become', 'become_method', and 'become_user' rather than running sudo

[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host vgetcd02 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will
default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in
version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
vgetcd02 | CHANGED | rc=0 >>
total 36
2361220 drwxr-xr-x 2 root root 4096 Aug 25 08:24 .
2361219 drwxr-xr-x 3 root root 4096 Aug 25 08:24 ..
2361223 -rw-r--r-- 1 root root 1017 Aug 25 08:24 ca.crt
2361225 -rw-r--r-- 1 root root 1094 Aug 25 08:24 healthcheck-client.crt
2361224 -rw------- 1 root root 1675 Aug 25 08:24 healthcheck-client.key
2361221 -rw-r--r-- 1 root root 1139 Aug 25 08:24 peer.crt
2361222 -rw------- 1 root root 1675 Aug 25 08:24 peer.key
2361226 -rw-r--r-- 1 root root 1139 Aug 25 08:24 server.crt
2361227 -rw------- 1 root root 1679 Aug 25 08:24 server.key



vagrant@vgetcd01:~$ sudo scp -r /tmp/${HOST2}/* vagrant@${HOST2}:/tmp
vagrant@192.168.10.4's password:
kubeadmcfg.yaml
peer.crt
peer.key
ca.crt
healthcheck-client.key
healthcheck-client.crt
server.crt
server.key
apiserver-etcd-client.key
apiserver-etcd-client.crt
vagrant@vgetcd03:~$ cd /tmp


vagrant@vgetcd01:~$ sudo ansible -b -i /vagrant/provisioning/hosts vgetcd03  -m shell -a "whoami"
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host vgetcd03 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will
default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in
version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
vgetcd03 | CHANGED | rc=0 >>
root

vagrant@vgetcd01:~$ sudo ansible -b -i /vagrant/provisioning/hosts vgetcd03  -m shell -a "cp -r /tmp/pki /etc/kubernetes/"
vagrant@vgetcd01:~$ sudo ansible -b -i /vagrant/provisioning/hosts vgetcd03  -m shell -a "ls -lai /etc/kubernetes/pki"
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host vgetcd03 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will
default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in
version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
vgetcd03 | CHANGED | rc=0 >>
total 20
2361091 drwxr-xr-x 3 root root 4096 Aug 25 18:15 .
2361087 drwxr-xr-x 4 root root 4096 Aug 25 18:15 ..
2361101 -rw-r--r-- 1 root root 1090 Aug 25 18:15 apiserver-etcd-client.crt
2361100 -rw------- 1 root root 1675 Aug 25 18:15 apiserver-etcd-client.key
2361092 drwxr-xr-x 2 root root 4096 Aug 25 18:15 etcd

vagrant@vgetcd01:~$ sudo ansible -b -i /vagrant/provisioning/hosts vgetcd03  -m shell -a "ls -lai /etc/kubernetes/pki/etcd"
[DEPRECATION WARNING]: Distribution Ubuntu 16.04 on host vgetcd03 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will
default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in
version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
vgetcd03 | CHANGED | rc=0 >>
total 36
2361092 drwxr-xr-x 2 root root 4096 Aug 25 18:15 .
2361091 drwxr-xr-x 3 root root 4096 Aug 25 18:15 ..
2361095 -rw-r--r-- 1 root root 1017 Aug 25 18:15 ca.crt
2361097 -rw-r--r-- 1 root root 1094 Aug 25 18:15 healthcheck-client.crt
2361096 -rw------- 1 root root 1675 Aug 25 18:15 healthcheck-client.key
2361093 -rw-r--r-- 1 root root 1139 Aug 25 18:15 peer.crt
2361094 -rw------- 1 root root 1679 Aug 25 18:15 peer.key
2361098 -rw-r--r-- 1 root root 1139 Aug 25 18:15 server.crt
2361099 -rw------- 1 root root 1675 Aug 25 18:15 server.key


vagrant@vgetcd01:/tmp$ find /tmp | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
/tmp
 |-192.168.10.2
 | |-kubeadmcfg.yaml

vagrant@vgetcd01:/tmp$ find /etc/kubernetes/pki | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
 | |-pki
 | | |-etcd
 | | | |-peer.crt
 | | | |-peer.key
 | | | |-ca.key
 | | | |-ca.crt
 | | | |-healthcheck-client.key
 | | | |-healthcheck-client.crt
 | | | |-server.crt
 | | | |-server.key
 | | |-apiserver-etcd-client.key
 | | |-apiserver-etcd-client.crt


 vagrant@vgetcd02:~$ find /tmp | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
/tmp
 |-kubeadmcfg.yaml
 vagrant@vgetcd02:~$ find /etc/kubernetes/pki | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
  | |-pki
  | | |-etcd
  | | | |-peer.crt
  | | | |-peer.key
  | | | |-ca.crt
  | | | |-healthcheck-client.key
  | | | |-healthcheck-client.crt
  | | | |-server.crt
  | | | |-server.key
  | | |-apiserver-etcd-client.key
  | | |-apiserver-etcd-client.crt


  vagrant@vgetcd03:/tmp$ find /tmp | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
/tmp
 |-kubeadmcfg.yaml

vagrant@vgetcd03:/tmp$ find /etc/kubernetes/pki | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
 | |-pki
 | | |-etcd
 | | | |-peer.crt
 | | | |-peer.key
 | | | |-ca.crt
 | | | |-healthcheck-client.key
 | | | |-healthcheck-client.crt
 | | | |-server.crt
 | | | |-server.key
 | | |-apiserver-etcd-client.key
 | | |-apiserver-etcd-client.crt



 vagrant@vgetcd01:~$ sudo kubeadm init phase etcd local --config=/tmp/192.168.10.2/kubeadmcfg.yaml
 [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests

 vagrant@vgetcd02:/tmp$ sudo kubeadm init phase etcd local --config=/tmp/kubeadmcfg.yaml
 [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"

 vagrant@vgetcd03:/tmp$ sudo kubeadm init phase etcd local --config=/tmp/kubeadmcfg.yaml
 [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"



 vagrant@vgetcd01:~$ sudo docker run --rm -it --net host -v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:3.3.10 etcdctl \
--cert-file /etc/kubernetes/pki/etcd/peer.crt \
--key-file /etc/kubernetes/pki/etcd/peer.key \
--ca-file /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://192.168.10.2:2379 cluster-health

 vagrant@vgetcd01:~$ sudo docker run --rm -it --net host -v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:3.3.10 etcdctl \
 > --cert-file /etc/kubernetes/pki/etcd/peer.crt \
 > --key-file /etc/kubernetes/pki/etcd/peer.key \
 > --ca-file /etc/kubernetes/pki/etcd/ca.crt \
 > --endpoints https://192.168.10.2:2379 cluster-health
 member 2af255134b508f21 is healthy: got healthy result from https://192.168.10.4:2379
 member 4a451414459653c0 is healthy: got healthy result from https://192.168.10.2:2379
 member 86ef4da6f07b0d20 is healthy: got healthy result from https://192.168.10.3:2379
 cluster is healthy


 vagrant@vgetcd01:~$ sudo docker run --rm -it --net host -v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:3.3.10 etcdctl \
--cert-file /etc/kubernetes/pki/etcd/peer.crt \
--key-file /etc/kubernetes/pki/etcd/peer.key \
--ca-file /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://192.168.10.2:2379  member list
 2af255134b508f21: name=infra2 peerURLs=https://192.168.10.4:2380 clientURLs=https://192.168.10.4:2379 isLeader=true
 4a451414459653c0: name=infra0 peerURLs=https://192.168.10.2:2380 clientURLs=https://192.168.10.2:2379 isLeader=false
 86ef4da6f07b0d20: name=infra1 peerURLs=https://192.168.10.3:2380 clientURLs=https://192.168.10.3:2379 isLeader=false

 vagrant@vgetcd01:~$ sudo docker run --rm -it --net host -v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:3.3.10 etcdctl \
--cert-file /etc/kubernetes/pki/etcd/peer.crt \
--key-file /etc/kubernetes/pki/etcd/peer.key \
--ca-file /etc/kubernetes/pki/etcd/ca.crt \
 --endpoints https://192.168.10.2:2379 --debug cluster-health
 Cluster-Endpoints: https://192.168.10.2:2379
 cURL Command: curl -X GET https://192.168.10.2:2379/v2/members
 member 2af255134b508f21 is healthy: got healthy result from https://192.168.10.4:2379
 member 4a451414459653c0 is healthy: got healthy result from https://192.168.10.2:2379
 member 86ef4da6f07b0d20 is healthy: got healthy result from https://192.168.10.3:2379
 cluster is healthy

 vagrant@vgetcd01:~$ curl -X GET https://192.168.10.2:2379/v2/members
 curl: (35) gnutls_handshake() failed: Certificate is bad

 vagrant@vgetcd01:~$ sudo curl --cert /etc/kubernetes/pki/etcd/peer.crt --key /etc/kubernetes/pki/etcd/peer.key https://192.168.10.2:2379
 curl: (60) server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
 More details here: http://curl.haxx.se/docs/sslcerts.html

 curl performs SSL certificate verification by default, using a "bundle"
  of Certificate Authority (CA) public keys (CA certs). If the default
  bundle file isn't adequate, you can specify an alternate file
  using the --cacert option.
 If this HTTPS server uses a certificate signed by a CA represented in
  the bundle, the certificate verification probably failed due to a
  problem with the certificate (it might be expired, or the name might
  not match the domain name in the URL).
 If you'd like to turn off curl's verification of the certificate, use
  the -k (or --insecure) option.





vagrant@vgetcd01:~$ sudo scp \
/etc/kubernetes/pki/apiserver-etcd-client.crt \
/etc/kubernetes/pki/apiserver-etcd-client.key \
/etc/kubernetes/pki/etcd/ca.crt  vagrant@vgmaster01:/tmp

vagrant@vgetcd01:/tmp$ sudo scp \
> /etc/kubernetes/pki/apiserver-etcd-client.crt \
> /etc/kubernetes/pki/apiserver-etcd-client.key \
> /etc/kubernetes/pki/etcd/ca.crt  vagrant@vgmaster01:/tmp
The authenticity of host 'vgmaster01 (192.168.10.5)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'vgmaster01,192.168.10.5' (ECDSA) to the list of known hosts.
vagrant@vgmaster01's password:
apiserver-etcd-client.crt
apiserver-etcd-client.key    
ca.crt


vagrant@vgmaster01:/tmp$ cd tmp && mkdir etcd && mv ca.crt etcd
vagrant@vgmaster01:/tmp$ ls
apiserver-etcd-client.crt  apiserver-etcd-client.key  etcd  vagrant-shell
vagrant@vgmaster01:/tmp$ ls etcd/
ca.crt

# reboot heartbeat if it takes too long and verify
vagrant@vgetcd01:~$ sudo systemctl restart heartbeat
vagrant@vgmaster01:/tmp$ nc -v 192.168.10.1 6443

vagrant@vgmaster01:/tmp$  sudo bash /vagrant/config_vgmaster01.sh

vagrant@vgmaster01:/tmp$ sudo kubeadm init --node-name vgmaster01 --config kubeadm-config.yaml --v=3
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 192.168.10.1:6443 --token x4xu0k.lkvy1to8xzujqxxp \
    --discovery-token-ca-cert-hash sha256:1ed586e19dd772475c581c0701a8cd03c0c52bc2e5bd5488536d0de38a60b158 \
    --control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.10.1:6443 --token x4xu0k.lkvy1to8xzujqxxp \
    --discovery-token-ca-cert-hash sha256:1ed586e19dd772475c581c0701a8cd03c0c52bc2e5bd5488536d0de38a60b158
#################################################################################################################



vagrant@vgmaster01:/tmp$ sudo kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(sudo kubectl version | base64 | tr -d '\n')"
The connection to the server localhost:8080 was refused - did you specify the right host or port?
serviceaccount/weave-net created
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created
daemonset.extensions/weave-net created


vagrant@vgmaster01:/tmp$ sudo kubectl --kubeconfig /etc/kubernetes/admin.conf get pod -n kube-system -w
NAME                                 READY   STATUS    RESTARTS   AGE
coredns-5c98db65d4-8s6z9             1/1     Running   0          3m47s
coredns-5c98db65d4-nqbs9             1/1     Running   0          3m47s
kube-apiserver-vgmaster01            1/1     Running   0          3m32s
kube-controller-manager-vgmaster01   1/1     Running   0          3m41s
kube-proxy-sknhl                     1/1     Running   0          3m47s
kube-scheduler-vgmaster01            1/1     Running   0          3m27s
weave-net-52v2n                      2/2     Running   0          64s

vagrant@vgmaster01:~$ mkdir -p $HOME/.kube
vagrant@vgmaster01:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
vagrant@vgmaster01:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

vagrant@vgmaster01:/tmp$ sudo kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes
NAME         STATUS   ROLES    AGE     VERSION
vgmaster01   Ready    master   4m57s   v1.15.3

vagrant@vgmaster01:~$ sudo kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
vgmaster01   Ready    master   3m12s   v1.15.3

vagrant@vgmaster01:~$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa.
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:rgPVyUQ5wCgO5qYaC3ZCPxitscjj2GLywc3K1yhIePc vagrant@vgmaster01
The key's randomart image is:
+---[RSA 4096]----+
|     o.o..       |
|... . . +        |
|oo..   + o       |
| *..  . +        |
|B B  .  S        |
|*@.*o  .         |
|B**.+=  .        |
|B+ooo E.         |
|oo+o  ..         |
+----[SHA256]-----+
vagrant@vgmaster01:~$ ssh-copy-id -i $HOME/.ssh/id_rsa.pub vagrant@vgmaster02
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/id_rsa.pub"
The authenticity of host 'vgmaster02 (192.168.10.6)' can't be established.
ECDSA key fingerprint is SHA256:1Z76nTl7aEpVhcnFIanMDmBiVXrhL9SXkGVxN7LcLD0.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@vgmaster02's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@vgmaster02'"
and check to make sure that only the key(s) you wanted were added.

vagrant@vgmaster01:~$ ssh vagrant@vgmaster02
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-131-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

144 packages can be updated.
91 updates are security updates.


Last login: Sat Aug 24 23:14:15 2019 from 10.0.2.2
vagrant@vgmaster02:~$ exit
logout
Connection to vgmaster02 closed.
vagrant@vgmaster01:~$




vagrant@vgmaster01:~$ sudo scp /etc/kubernetes/pki/ca.crt \
/etc/kubernetes/pki/ca.key \
/etc/kubernetes/pki/sa.key \
/etc/kubernetes/pki/sa.pub \
/etc/kubernetes/pki/front-proxy-ca.crt \
/etc/kubernetes/pki/front-proxy-ca.key \
/etc/kubernetes/pki/apiserver-etcd-client.crt \
/etc/kubernetes/pki/apiserver-etcd-client.key \
/etc/kubernetes/admin.conf vagrant@vgmaster02:/tmp

vagrant@vgmaster02:/tmp$ cd /tmp && mkdir etcd
vagrant@vgmaster01:~$ sudo scp  /etc/kubernetes/pki/etcd/ca.crt vagrant@vgmaster02:/tmp/etcd

vagrant@vgmaster02:/tmp$ ls
admin.conf  apiserver-etcd-client.crt  apiserver-etcd-client.key  ca.crt  ca.key  etcd  front-proxy-ca.crt  front-proxy-ca.key  sa.key  sa.pub  vagrant-shell
vagrant@vgmaster02:/tmp$ ls etcd/
ca.crt

vagrant@vgmaster02:/tmp$ sudo bash /vagrant/config_vgmaster02.sh

# reboot heart if it takes too long and verify
vagrant@vgetcd01:~$ sudo systemctl restart heartbeat
vagrant@vgmaster02:/tmp$ nc -v 192.168.10.1 6443
Connection to 192.168.10.1 6443 port [tcp/*] succeeded!
^C

vagrant@vgmaster02:~$ sudo kubeadm join 192.168.10.1:6443 --apiserver-advertise-address="192.168.10.6" \
--node-name vgmaster02 --token x4xu0k.lkvy1to8xzujqxxp \
--discovery-token-ca-cert-hash sha256:1ed586e19dd772475c581c0701a8cd03c0c52bc2e5bd5488536d0de38a60b158 \
--control-plane --v=3

vagrant@vgmaster02:~$ mkdir -p $HOME/.kube
vagrant@vgmaster02:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
vagrant@vgmaster02:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
vagrant@vgmaster02:~$ kubectl get nodes
NAME         STATUS   ROLES    AGE    VERSION
vgmaster01   Ready    master   28m    v1.15.3
vgmaster02   Ready    master   2m8s   v1.15.3


vagrant@vgmaster01:~$ kubectl -n kube-system get cm kubeadm-config -oyaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      certSANs:
      - 192.168.10.1
      extraArgs:
        advertise-address: 192.168.10.1
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta2
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controlPlaneEndpoint: 192.168.10.1:6443
    controllerManager: {}
    dns:
      type: CoreDNS
    etcd:
      external:
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        endpoints:
        - https://192.168.10.2:2379
        - https://192.168.10.3:2379
        - https://192.168.10.4:2379
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
    imageRepository: k8s.gcr.io
    kind: ClusterConfiguration
    kubernetesVersion: v1.15.3
    networking:
      dnsDomain: cluster.local
      podSubnet: 192.168.0.0/16
      serviceSubnet: 10.96.0.0/12
    scheduler: {}
  ClusterStatus: |
    apiEndpoints:
      vgmaster01:
        advertiseAddress: 192.168.10.5
        bindPort: 6443
      vgmaster02:
        advertiseAddress: 192.168.10.6
        bindPort: 6443
    apiVersion: kubeadm.k8s.io/v1beta2
    kind: ClusterStatus
kind: ConfigMap
metadata:
  creationTimestamp: "2019-08-25T18:57:07Z"
  name: kubeadm-config
  namespace: kube-system
  resourceVersion: "2356"
  selfLink: /api/v1/namespaces/kube-system/configmaps/kubeadm-config
  uid: ec5e1468-f2d3-47f0-ba2e-4bd70190826a
vagrant@vgmaster01:~$

vagrant@vgmaster02:~$  kubectl -n kube-system get cm kubeadm-config -oyaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      certSANs:
      - 192.168.10.1
      extraArgs:
        advertise-address: 192.168.10.1
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta2
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controlPlaneEndpoint: 192.168.10.1:6443
    controllerManager: {}
    dns:
      type: CoreDNS
    etcd:
      external:
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        endpoints:
        - https://192.168.10.2:2379
        - https://192.168.10.3:2379
        - https://192.168.10.4:2379
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
    imageRepository: k8s.gcr.io
    kind: ClusterConfiguration
    kubernetesVersion: v1.15.3
    networking:
      dnsDomain: cluster.local
      podSubnet: 192.168.0.0/16
      serviceSubnet: 10.96.0.0/12
    scheduler: {}
  ClusterStatus: |
    apiEndpoints:
      vgmaster01:
        advertiseAddress: 192.168.10.5
        bindPort: 6443
      vgmaster02:
        advertiseAddress: 192.168.10.6
        bindPort: 6443
    apiVersion: kubeadm.k8s.io/v1beta2
    kind: ClusterStatus
kind: ConfigMap
metadata:
  creationTimestamp: "2019-08-25T18:57:07Z"
  name: kubeadm-config
  namespace: kube-system
  resourceVersion: "2356"
  selfLink: /api/v1/namespaces/kube-system/configmaps/kubeadm-config
  uid: ec5e1468-f2d3-47f0-ba2e-4bd70190826a
vagrant@vgmaster02:~$


vagrant@vgmaster01:~$ kubectl get pod -n kube-system -w
NAME                                 READY   STATUS    RESTARTS   AGE
coredns-5c98db65d4-26lq8             1/1     Running   0          33m
coredns-5c98db65d4-cr6k5             1/1     Running   0          33m
kube-apiserver-vgmaster01            1/1     Running   0          32m
kube-apiserver-vgmaster02            1/1     Running   0          6m58s
kube-controller-manager-vgmaster01   1/1     Running   0          32m
kube-controller-manager-vgmaster02   1/1     Running   0          6m58s
kube-proxy-btkw6                     1/1     Running   0          6m58s
kube-proxy-ktr9v                     1/1     Running   0          33m
kube-scheduler-vgmaster01            1/1     Running   0          32m
kube-scheduler-vgmaster02            1/1     Running   0          6m58s
weave-net-56f49                      2/2     Running   0          31m
weave-net-xtpwb                      2/2     Running   1          6m58s




vagrant@vgworker01:~$ nc -v 192.168.10.1 6443
Connection to 192.168.10.1 6443 port [tcp/*] succeeded!
vagrant@vgworker01:~$ sudo kubeadm join 192.168.10.1:6443 --token x4xu0k.lkvy1to8xzujqxxp --discovery-token-ca-cert-hash sha256:1ed586e19dd772475c581c0701a8cd03c0c52bc2e5bd5488536d0de38a60b158
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.15" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
[kubelet-check] Initial timeout of 40s passed.

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.


vagrant@vgmaster01:~$ kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
vgmaster01   Ready    master   56m   v1.15.3
vgmaster02   Ready    master   29m   v1.15.3
vgworker01   Ready    <none>   10m   v1.15.3


vagrant@vgmaster01:/tmp$ sudo kubectl --kubeconfig /etc/kubernetes/admin.conf get nodes
NAME         STATUS   ROLES    AGE   VERSION
vgmaster01   Ready    master   75m   v1.15.3
vgmaster02   Ready    master   47m   v1.15.3
vgworker01   Ready    <none>   38m   v1.15.3
vgworker02   Ready    <none>   13m   v1.15.3
vgworker03   Ready    <none>   17m   v1.15.3                


~~~~
smoke tests
~~~~
Web UI (Dashboard)  
<https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#deploying-the-dashboard-ui>
~~~~
~~~~
Creating Highly Available clusters with kubeadm
<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/>
Set up a High Availability etcd cluster with kubeadm
<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/>
Customizing control plane configuration with kubeadm
<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/>
Container runtimes
<https://kubernetes.io/docs/setup/production-environment/container-runtimes/>
Installing kubeadm
<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/>


kubeadm init
<https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/>
package v1beta2
kubeadm configuration file format
<https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2#ClusterConfiguration>

Weave Troubleshooting
<https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#troubleshooting>

Manual certificate distribution
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#manual-certs
~~~~
