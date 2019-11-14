#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive

# Add delay to prevent "vagrant reload" from failing
echo 'pre-up sleep 2' >> /etc/network/interfaces

echo '==> Cleaning up tmp'
rm -rf /tmp/*

# Cleanup apt cache
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/user/.bash_history
rm -f /home/vagrant/.bash_history

# Clean up log files
find /var/log -type f | while read -r f; do echo -ne '' > "${f}"; done;

echo '==> Clearing last login information'
true > /var/log/lastlog
true > /var/log/wtmp
true > /var/log/btmp

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early before the large files are deleted
sync
