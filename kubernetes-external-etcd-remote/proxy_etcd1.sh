#!/bin/bash
apt-get update
apt-get install -y haproxy=1.6.3-1ubuntu0.2
mv /etc/haproxy/haproxy.cfg{,.back}
cat <<EOT | sudo tee /etc/haproxy/haproxy.cfg
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
        ssl-default-bind-options no-sslv3

defaults
        log     global
        retries 2
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 3000ms
        timeout client 5000ms
        timeout server 5000ms
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

frontend kubernetes
        bind 192.168.10.1:6443
        option tcplog
        mode tcp
        default_backend kubernetes-master-nodes

backend kubernetes-master-nodes
        mode tcp
        balance roundrobin
        option tcp-check
        server vgmaster01 192.168.10.5:6443 check fall 3 rise 2
        server vgmaster02 192.168.10.6:6443 check fall 3 rise 2
EOT
cat >> /etc/sysctl.conf <<EOF
# enable net.ipv4.ip_nonlocal_bind sysctl option,
# to allow system services binding on the non-local IP.
net.ipv4.ip_nonlocal_bind=1
EOF
sysctl -p
systemctl stop haproxy
systemctl start haproxy
systemctl status haproxy
echo "====================================================================================="
netstat -ntlp
echo "====================================================================================="
apt-get -y install heartbeat=1:3.0.6-2
systemctl enable heartbeat
cat <<EOT | sudo tee /etc/ha.d/authkeys
auth 1
1 md5 bb77d0d3b3f239fa5db73bdf27b8d29a
EOT
chmod 600 /etc/ha.d/authkeys
cat <<EOT | sudo tee /etc/ha.d/ha.cf
#       keepalive: how many seconds between heartbeats
#
keepalive 2
#
#       deadtime: seconds-to-declare-host-dead
#
deadtime 10
#
#       What UDP port to use for udp or ppp-udp communication?
#
udpport        694
bcast  eth1
mcast eth1 225.0.0.1 694 1 0
ucast eth1 192.168.10.3
#       What interfaces to heartbeat over?
udp     eth1
#
#       Facility to use for syslog()/logger (alternative to log/debugfile)
#
logfacility     local0
#
#       Tell what machines are in the cluster
#       node    nodename ...    -- must match uname -n
node    vgetcd01
node    vgetcd02
EOT
cat <<EOT | sudo tee /etc/ha.d/haresources
vgetcd01 192.168.10.1
EOT
systemctl stop heartbeat && systemctl start heartbeat
systemctl restart heartbeat
echo "====================================================================================="
ip a
echo "====================================================================================="
echo "====================================================================================="
nc -v 192.168.10.1 6443
echo "====================================================================================="
hostnamectl status
# Container runtimes
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# Install Docker CE
# Set up the repository:
## Install packages to allow apt to use a repository over HTTPS
apt-get update
apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
## Install Docker CE.
apt-get update && apt-get install docker-ce=18.06.2~ce~3-0~ubuntu -y
echo "====================================================================================="
docker -v
echo "====================================================================================="
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
# Installing kubeadm
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
echo "=============================kubeadm========================================================"
kubeadm version
echo "============================================================================================"
echo "=============================kubectl========================================================"
kubectl version
echo "============================================================================================"
echo "=============================kubelet========================================================"
kubelet --version
echo "============================================================================================"
hostnamectl status
cat << EOF > /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd
Restart=always
EOF
systemctl daemon-reload
systemctl restart kubelet
export HOST0=192.168.10.2
export HOST1=192.168.10.3
export HOST2=192.168.10.4
mkdir -p /tmp/${HOST0}/ /tmp/${HOST1}/ /tmp/${HOST2}/
ETCDHOSTS=(${HOST0} ${HOST1} ${HOST2})
NAMES=("infra0" "infra1" "infra2")
for i in "${!ETCDHOSTS[@]}"; do
HOST=${ETCDHOSTS[$i]}
NAME=${NAMES[$i]}
cat << EOF > /tmp/${HOST}/kubeadmcfg.yaml
apiVersion: "kubeadm.k8s.io/v1beta1"
kind: ClusterConfiguration
etcd:
    local:
        serverCertSANs:
        - "${HOST}"
        peerCertSANs:
        - "${HOST}"
        extraArgs:
            initial-cluster: ${NAMES[0]}=https://${ETCDHOSTS[0]}:2380,${NAMES[1]}=https://${ETCDHOSTS[1]}:2380,${NAMES[2]}=https://${ETCDHOSTS[2]}:2380
            initial-cluster-state: new
            name: ${NAME}
            listen-peer-urls: https://${HOST}:2380
            listen-client-urls: https://${HOST}:2379
            advertise-client-urls: https://${HOST}:2379
            initial-advertise-peer-urls: https://${HOST}:2380
EOF
done
kubeadm init phase certs etcd-ca
## Create certificates for the etcd3 node
echo "==============================Create certificates for the etcd3 node======================"
kubeadm init phase certs etcd-server --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
cp -R /etc/kubernetes/pki /tmp/${HOST2}/
### cleanup non-reusable certificates
find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete
echo "============================================================================================"
## Create certificates for the etcd2 node
echo "==============================Create certificates for the etcd2 node======================"
kubeadm init phase certs etcd-server --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
cp -R /etc/kubernetes/pki /tmp/${HOST1}/
### cleanup non-reusable certificates again
find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete
echo "============================================================================================"
### Create certificates for the this local node
echo "==============================Create certificates for local node the etcd1 node======================"
kubeadm init phase certs etcd-server --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
# No need to move the certs because they are for this node# clean up certs that should not be copied off this host
# clean up certs that should not be copied off this host
find /tmp/${HOST2} -name ca.key -type f -delete
find /tmp/${HOST1} -name ca.key -type f -delete
echo "============================================================================================"
hostnamectl status
