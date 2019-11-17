#!/bin/bash -eux

echo '==> Configuring user'

sed -i -r 's/^autologin-user=.+$/autologin-user=/' /etc/lightdm/lightdm.conf
localestl set-locale "LANG=en_US.utf8"
