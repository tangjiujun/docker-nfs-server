### Description

> This image exports /nfsshare via NFS v3. Since some Linux kernels have issues running NFS v4 daemons in containers, only NFS v3 is opened in this image.

### Usage

```bash
docker run -d --privileged --restart=unless-stopped \
    -v /local_directory:/nfsshare \
    -p 111:111 -p 111:111/udp \
    -p 2049:2049 -p 2049:2049/udp \
    -p 32765-32768:32765-32768 -p 32765-32768:32765-32768/udp \
    --name nfs-server tangjiujun/nfs-server:v1.0
```

### Configuration：

You can configuration export directory and options by set docker environment variables.

* `EXPORT_DIR` default is `/nfsshare`
* `EXPORT_OPTS` default is `*(rw,fsid=0,insecure,no_root_squash,no_subtree_check,sync)`

### Issue

Image run on macOS has an error: /nfsshare does not support NFS export
