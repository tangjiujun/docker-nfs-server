#!/bin/bash

set -xe

NFS_EXPORT_DIR=${EXPORT_DIR:-"/nfsshare"}
NFS_EXPORT_OPTS=${EXPORT_OPTS:-"*(rw,fsid=0,insecure,no_root_squash,no_subtree_check,sync)"}

mkdir -p $NFS_EXPORT_DIR
echo "$NFS_EXPORT_DIR   $NFS_EXPORT_OPTS" > /etc/exports


# Fixed nlockmgr port
echo 'fs.nfs.nlm_tcpport=32768' >> /etc/sysctl.conf
echo 'fs.nfs.nlm_udpport=32768' >> /etc/sysctl.conf
sysctl -p > /dev/null

mount -t nfsd nfds /proc/fs/nfsd

rpcbind -w
rpc.nfsd -N 2 -V 3 -N 4 -N 4.1 8
exportfs -arfv

rpc.statd -p 32765 -o 32766
rpc.mountd -N 2 -V 3 -N 4 -N 4.1 -p 32767 -F