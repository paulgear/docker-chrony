#!/bin/bash
rm -fv /etc/ssh/ssh_host_*key*
SSH=/root/.ssh
mkdir $SSH
chmod 700 $SSH
echo "$SSH_AUTHORIZED_KEYS" > $SSH/authorized_keys
chmod 600 $SSH/authorized_keys
dpkg-reconfigure openssh-server
service ssh start
/usr/sbin/chronyd "$@"
