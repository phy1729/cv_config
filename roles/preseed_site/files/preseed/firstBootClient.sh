#!/bin/bash

# Wait until we can talk to the repo
while true; do
    if ping -c1 repo.collegiumv.org ; then
        break
    fi
    sleep 5
done

# This script runs the first boot install tasks on the hardware
xbps-install -R http://repo.collegiumv.org/current -Syu
xbps-install -R http://repo.collegiumv.org/current -Syu
xbps-install -R http://repo.collegiumv.org/current -y curl fbv ansible git-all python-pip

# Install ipaddr filter for python
pip install netaddr

# Attempt to run the main ansible installer
ansible-pull -U https://github.com/collegiumv/cv_config.git

# Remove the firstboot script
rm -rf /etc/sv/firstboot
rm -rf /var/service/firstboot

# Lock the lcoal account used for recovery of failed ansible-pull
passwd -l cv

# Reboot so that everything starts up cleanly
shutdown -r now
