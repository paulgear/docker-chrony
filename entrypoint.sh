#!/bin/bash
rm -fv /etc/ssh/ssh_host_*key*
dpkg-reconfigure openssh-server
service ssh start
/usr/sbin/chronyd "$@"
