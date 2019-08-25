#!/bin/bash
mkdir -p /etc/kubernetes/pki/etcd
cp /tmp/ca.crt \
/tmp/ca.key \
/tmp/sa.pub \
/tmp/sa.key \
/tmp/apiserver-etcd-client.crt \
/tmp/apiserver-etcd-client.key \
/tmp/front-proxy-ca.crt \
/tmp/front-proxy-ca.key  /etc/kubernetes/pki/
cp -r etcd/ /etc/kubernetes/pki/
cp /tmp/admin.conf /etc/kubernetes/admin.conf
hostnamectl status
