#!/bin/sh

# Configure netatalk
sed -i -e "s/volsizelimit:0/volsizelimit:${VOLSIZELIMIT:-500000}/" /etc/netatalk/AppleVolumes.default

# Fix backup permissions
chown -R timecapsule:timecapsule /backup
chmod ug+rw /backup
find /backup -type d -print0 | xargs -0 chmod ug+rwx

/etc/init.d/dbus start
/usr/sbin/avahi-daemon --no-chroot -D
/etc/init.d/netatalk start
tail -F /log/afpd.log
/etc/init.d/netatalk stop
/usr/sbin/avahi-daemon -k
/etc/init.d/dbus stop
