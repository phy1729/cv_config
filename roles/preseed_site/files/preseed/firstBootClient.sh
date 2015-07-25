#!/bin/bash

# This script runs the first boot install tasks on the hardware

# Install the proprietary gfx installers
apt-get install -y fglrx

# Be absolutely sure deployment software is installed
apt-get install -y python-dev python-pip git fbi
pip install ansible

# Show the installer splash
curl -o /tmp/background.bmp http://preseed.collegiumv.org/CVBackground5.bmp
fbi -d /dev/fb0 -T 1 -a /tmp/background.bmp

# Attempt to run the main ansible installer
ansible-pull -U https://github.com/collegiumv/cv_config.git

# Reboot so that everything starts up cleanly
shutdown -r now
