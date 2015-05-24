#!/bin/bash

# This script runs the first boot install tasks on the hardware

# Install the proprietary gfx installers, if any
apt-get install -y ubuntu-drivers-common
ubuntu-drivers autoinstall

# Be absolutely sure ansible is installed
apt-get install -y python-dev python-pip git
pip install ansible

# Attempt to run the main ansible installer
ansible-pull -U https://github.com/phy1729/cv_config_bleeding.git

# Reboot so that everything starts up cleanly
shutdown -r now
