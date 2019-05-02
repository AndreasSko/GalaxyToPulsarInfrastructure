#!/bin/bash

mkfs -t xfs /dev/vdb
mkdir -p /srv/galaxy-storage
echo "/dev/vdb  /srv/galaxy-storage xfs defaults,nofail 0 2" >> /etc/fstab
mount /srv/galaxy-storage
chown centos:centos -R /srv/galaxy-storage
