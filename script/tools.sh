#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive

echo "==> Installing tools"
apt-get install -y mc vim unzip firefox net-tools wget curl rsync nano
