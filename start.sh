#!/bin/sh

test -n "${VOLPATH}" || VOLPATH="/backup"

# Configure netatalk
sed -i -e "s/volsizelimit:0/volsizelimit:${VOLSIZELIMIT:-500000}/" /etc/netatalk/AppleVolumes.default
sed -i -e "s:^/backup:${VOLPATH}:" /etc/netatalk/AppleVolumes.default

# Fix backup permissions
find ${VOLPATH} -not \( -user timecapsule -a -group timecapsule \) -exec chown timecapsule:timecapsule {} +
find ${VOLPATH} -type d -a -not -perm -0770 -exec chmod ug+rwx {} +

/etc/init.d/dbus start
/usr/sbin/avahi-daemon --no-chroot -D
/etc/init.d/netatalk start
tail -F /log/afpd.log
/etc/init.d/netatalk stop
/usr/sbin/avahi-daemon -k
/etc/init.d/dbus stop
