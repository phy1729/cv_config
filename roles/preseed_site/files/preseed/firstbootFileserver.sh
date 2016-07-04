#!/bin/bash

# Wait until we can talk to the repo
while true; do
    if ping -c1 repo.collegiumv.org ; then
        break
    fi
    sleep 5
done

# Install ZFS, which will do a DKMS build
xbps-install -R http://repo.collegiumv.org/current -Syu
xbps-install -R http://repo.collegiumv.org/current -Syu
xbps-install -R http://repo.collegiumv.org/current -y zfs
modprobe zfs

# Is there a pool we can import?
poolName="$(zpool import | awk '/pool: /{print $2}')"

if [ -z $poolName ] ; then
    # No pool was found, so create one.
    # Given the BIOS state is known,
    # we can safely assume the vdev names
    zpool create -f tank raidz2 /dev/sd{b,c,d,e}
else
    # A pool did exist, so lets import it
    zpool import -f $poolName
fi

# Remove the firstboot script
rm -rf /etc/sv/firstboot
rm -rf /var/service/firstboot

# Reboot to make sure we get the DKMS module correctly
shutdown -r now
