#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive

SSH_USER=user
SSH_USER_HOME="/home/${SSH_USER}"

echo "==> Installing linux headers: `uname -r`"
apt-get install -y build-essential dkms linux-headers-$(uname -r) gcc make perl

echo '==> Installing VirtualBox guest additions'
# Assume that we've installed all the prerequisites:
# kernel-headers-$(uname -r) kernel-devel-$(uname -r) gcc make perl
# from the install media

mount -o loop "${SSH_USER_HOME}/VBoxGuestAdditions.iso" /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf "${SSH_USER_HOME}/VBoxGuestAdditions.iso"

usermod -aG vboxsf ${SSH_USER}
