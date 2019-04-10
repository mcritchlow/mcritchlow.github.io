---
layout: post
title:  "Setting up a local Kuberentes environment on Arch Linux"
date:   2019-02-21
categories: devops kubernetes helm arch
---

### Installing Libvirt/Qemu

On Arch linux, and hopefully most systemd-based Linux distributions, the following steps were necessary in preparation
to install the vagrant libvirt plugin, as well as the `kvm2` driver for
Minikube.

The majority of this information was taken from the [Arch Wiki][libvirt-arch] entry on Libvirt.

### Verify KVM support
While not mandatory, we want to use KVM as the hypervisor for libvirt/Qemu
```
lsmod | grep kvm
```
If this command returns nothing, you may have to manually load the module in the kernel.

### Packages
This installs what I believe to be the core packages necessary for using libvirt/qemu.
```
sudo pacman -Suy libvirt qemu firewalld ebtables dnsmasq bridge-utils openbsd-netcat
```

### Configuration
The firewalld configuration file needed to be updated to use iptables.
```
vi /etc/firewalld/firewalld.conf
# Last line (change FirewallBackend to iptables from nftables)
```

### Add user to libvirt group
This allows for passwordless access to the libvirt RW daemon socket
```
sudo usermod -a -G libvirt <user>
```

### SystemD
```
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service virtlogd.service
```

### Install libvirt plugin
```
vagrant plugin install vagrant-libvirt
```

## Installing Minikube and Kubectl

I recently setup a local minikube installation for testing Helm charts for the
Project Surfliner.

> If you're using VirtualBox, you can skip installing the kvm2 driver and setup

Here's what I needed for the install:

1. Install `minikube` and `kubectl`. Thankfully these are in the repos now

```
sudo pacman -Sy minikube kubectl
```

2. Install Helm and the KVM2 driver from the AUR. There are a few options, I
used:
- https://aur.archlinux.org/kubernetes-helm.git
- https://aur.archlinux.org/docker-machine-driver-kvm2.git


3. Configure Minikube to use the `kvm2` driver

```
minikube config set vm-driver kvm2
```

4. I also bumped the resources for minikube, because Java..

```

minikube config set cpus 4
minikube config set memory 4000
```

[libvirt-arch]:https://wiki.archlinux.org/index.php/Libvirt


