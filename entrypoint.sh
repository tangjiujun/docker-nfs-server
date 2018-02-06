#!/bin/bash

set -xe

NFS_EXPORT_DIR="/nfsshare"
if test -n "$EXPORT_DIR"; then
    NFS_EXPORT_DIR=$EXPORT_DIR
fi

NFS_EXPORT_OPTS="*(rw,fsid=0,insecure,no_root_squash,no_subtree_check,sync)"
if test -n "$EXPORT_OPTS"; then
    NFS_EXPORT_OPTS=$EXPORT_OPTS
fi

mkdir -p $NFS_EXPORT_DIR
echo "$NFS_EXPORT_DIR   $NFS_EXPORT_OPTS" > /etc/exports


mount -t nfsd nfsd /proc/fs/nfsd
# Fixed nlockmgr port
echo 'fs.nfs.nlm_tcpport=32768' >> /etc/sysctl.conf
echo 'fs.nfs.nlm_udpport=32768' >> /etc/sysctl.conf
sysctl -p > /dev/null

rpcbind -w
rpc.nfsd -N 2 -V 3 -N 4 -N 4.1 8
exportfs -arfv
rpc.statd -p 32765 -o 32766
rpc.mountd -N 2 -V 3 -N 4 -N 4.1 -p 32767 -F
