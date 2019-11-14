#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive

echo '==> Removing PackageKit'
apt-get -y purge packagekit packagekit-tools

echo '==> Updating list of repositories'
apt-get -y update

# Remove any pre-installed virtualbox packages
apt-get -y purge virtualbox*

echo '==> Performing dist-upgrade (all packages and kernel)'
apt-get -y dist-upgrade
