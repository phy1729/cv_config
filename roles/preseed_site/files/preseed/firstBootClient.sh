#!/bin/bash

# This script runs the first boot install tasks on the hardware

# Install the proprietary gfx installers
apt-get install ubuntu-drivers-common

UBUNTUDRIVERS=`ubuntu-drivers list`

if [[ $UBUNTUDRIVERS == *"fglrx"* ]]
then
    apt-get install -y fglrx
fi

if [[ $UBUNTUDRIVERS == *"nvidia"* ]]
then
    apt-get install -y nvidia-340 nvidia-331
fi

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
