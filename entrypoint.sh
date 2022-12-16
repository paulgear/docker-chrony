#!/bin/bash

# install authorized_keys
SSH=/root/.ssh
mkdir $SSH
chmod 700 $SSH
echo "$SSH_AUTHORIZED_KEYS" > $SSH/authorized_keys
chmod 600 $SSH/authorized_keys

# set up ssh server
rm -fv /etc/ssh/ssh_host_*key*
dpkg-reconfigure openssh-server
service ssh start
service apache2 start

# add PTP device to chrony configuration, if present
if [ -e /dev/ptp0 ]; then
    echo "refclock PHC /dev/ptp0 dpoll -2" >> /etc/chrony/chrony.conf
fi

(sleep 10; chmod 755 /var/log/chrony) &
/usr/sbin/chronyd "$@"
