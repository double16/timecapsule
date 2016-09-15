#!/bin/sh -e

mkdir -p /tmp/afptest
mount_afp "afp://timecapsule:timecapsule@localhost/Time Capsule" /tmp/afptest
sleep 3
umount /tmp/afptest

