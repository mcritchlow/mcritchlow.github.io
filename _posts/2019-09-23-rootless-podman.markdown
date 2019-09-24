---
layout: post
title:  "Setting up rootless buildah/podman on Arch Linux"
date:   2019-09-23
---

## Support Unprivileged User Namespaces
Arch Linux doesn't have this enabled by default, so we need to enable it
```
~ % cat /etc/sysctl.d/userns.conf
kernel.unprivileged_userns_clone=1
```

## Allow non-root user to use UID/GID in containers
> A normal, non-root user in Linux usually only has access to their own user—one UID. Using the extra UIDs and GIDs in a rootless container lets you act as a different user, something that normally requires root privileges (or logging in as that other user with their password). The mapping executables newuidmap and newgidmap use their elevated privileges to grant us access to extra UIDs and GIDs according to the mappings configured in /etc/subuid and /etc/subgid without being root or having permission to log in as the users.

Modify existing user to add id ranges:
```
sudo touch /etc/{subgid,subuid} # if they don't already exist
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 johndoe
grep johndoe /etc/subuid /etc/subgid
/etc/subuid:johndoe:100000:65535
/etc/subgid:johndoe:100000:65535
```

## Use fuse-overlayfs for rootless driver
> Note: If you installed podman prior to fuse-overlayfs, you need to remove
> ~/.local/share/containers and ~/.config/containers directories. Then, in a new
> terminal, a `podman info` should regenerate things

Install fuse-overlayfs for faster rootless builds: https://aur.archlinux.org/packages/fuse-overlayfs/


References:
- https://www.redhat.com/sysadmin/rootless-podman
- https://wiki.archlinux.org/index.php/Buildah
- https://github.com/containers/libpod/blob/master/docs/tutorials/rootless_tutorial.md
