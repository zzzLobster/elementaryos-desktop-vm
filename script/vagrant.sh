#!/bin/bash -eux

echo '==> Configuring settings for vagrant'

VAGRANT_USER='vagrant'
VAGRANT_HOME="/home/${VAGRANT_USER}"
VAGRANT_INSECURE_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

# Add vagrant user if it doesn't already exist
if ! id -u ${VAGRANT_USER} >/dev/null 2>&1; then
  echo "==> Creating ${VAGRANT_USER}"
  /usr/sbin/groupadd ${VAGRANT_USER}
  /usr/sbin/useradd ${VAGRANT_USER} -g ${VAGRANT_USER}
  echo "${VAGRANT_USER}:${VAGRANT_USER}" | chpasswd
fi

echo '==> Installing Vagrant SSH key'
# shellcheck disable=SC2174
mkdir -pm 700 "${VAGRANT_HOME}/.ssh"
# https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
echo "${VAGRANT_INSECURE_KEY}" > "${VAGRANT_HOME}/.ssh/authorized_keys"
chmod 0600 "${VAGRANT_HOME}/.ssh/authorized_keys"
chown -R ${VAGRANT_USER}:${VAGRANT_USER} "${VAGRANT_HOME}/.ssh"

# Set up sudo
echo "==> Giving ${VAGRANT_USER} sudo powers"
echo "${VAGRANT_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant

# keep proxy settings through sudo
echo 'Defaults env_keep += "HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY NO_PROXY PATH"' >> /etc/sudoers

# Fix stdin not being a tty
sed -i 's/^\(.*requiretty\)$/#\1/' /etc/sudoers
if grep -q -E "^mesg n$" /root/.profile && sed -i "s/^mesg n$/tty -s \\&\\& mesg n/g" /root/.profile; then
  echo '==> Fixed stdin not being a tty.'
fi

echo "[InputSource0]
xkb=us

[User]
XSession=pantheon
SystemAccount=true" > /var/lib/AccountsService/users/vagrant
chown root:root /var/lib/AccountsService/users/vagrant
chmod 644 /var/lib/AccountsService/users/vagrant
