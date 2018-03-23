# Docker google-drive-ocamlfuse
1. Clone this repository
2. build the image
```bash
docker build -t docker-google-drive-ocamlfuse .
```

3. Specify the mount dirs
```bash
mount --bind /mnt/drive /mnt/drive
mount --make-shared /mnt/drive
```

4. Create and run the docker container
```bash
docker run -d --security-opt apparmor:unconfined --name gdrive --cap-add mknod --cap-add sys_admin --device=/dev/fuse -v /mnt/gdrive:/mnt/gdrive:shared docker-google-drive-ocamlfuse
```

5. View the logs and authorize using the url
```
docker logs gdrive
```

# Thanks to [docker-google-drive-ocamlfuse](https://github.com/mitcdh/docker-google-drive-ocamlfuse) and [google-drive-ocamlfuse](https://github.com/astrada/google-drive-ocamlfuse)