---
layout: post
title:  "Setting up rootless buildah/podman on Arch Linux"
date:   2019-09-23
---

Arch Linux doesn't have this enabled by default, so we need to enable it
```
~ % cat /etc/sysctl.d/userns.conf
kernel.unprivileged_userns_clone=1
```

Modify existing user to add namespace ranges:
```
sudo touch /etc/{subgid,subuid} # if they don't already exist
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 johndoe
grep johndoe /etc/subuid /etc/subgid
/etc/subuid:johndoe:100000:65535
/etc/subgid:johndoe:100000:65535
```

Install fuse-overlayfs for faster rootless builds: https://aur.archlinux.org/packages/fuse-overlayfs/

References:
- https://wiki.archlinux.org/index.php/Buildah
- https://github.com/containers/libpod/blob/master/docs/tutorials/rootless_tutorial.md
