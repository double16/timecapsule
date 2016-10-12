#!/bin/sh

test -n "${VOLPATH}" || VOLPATH="/backup"

# Adjust user/group
sed -i -e "s/:1000:1000:/:${PUID:-1000}:${PGID:-1000}:/" /etc/passwd

# Configure netatalk
sed -i -e "s/vol size limit = 0/vol size limit = ${VOLSIZELIMIT:-500000}/" /etc/afp.conf
sed -i -e "s:path = /backup:path = ${VOLPATH}:" /etc/afp.conf
cat /etc/afp.conf

# Fix backup permissions
mkdir -p ${VOLPATH} || exit 1
find ${VOLPATH} -not \( -user timecapsule -a -group timecapsule \) -exec chown timecapsule:timecapsule {} +
find ${VOLPATH} -type d -a -not -perm -0770 -exec chmod ug+rwx {} +

mkdir -p /var/run/dbus
rm -f /var/run/dbus.pid
/usr/bin/dbus-uuidgen --ensure=/etc/machine-id
/usr/bin/dbus-daemon --system

/usr/sbin/avahi-daemon --no-chroot -D

rm -f /tmp/log
mkfifo /tmp/log

/sbin/netatalk

cat /tmp/log

killall netatalk
/usr/sbin/avahi-daemon -k
killall dbus-daemon
