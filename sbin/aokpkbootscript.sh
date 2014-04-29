#!/system/bin/sh

# Make sure that mpdecision and thermal-engine are inactive from the dirty flashers!
mount -o rw,remount /system;
[ -f /system/bin/mpdecision.bak ] || mv /system/bin/mpdecision /system/bin/mpdecision.bak
[ -f /system/bin/thermal-engine-hh-bak ] || mv /system/bin/thermal-engine-hh /system/bin/thermal-engine-hh-bak
if [ ! -e /system/etc/init.d ]; then
mkdir /system/etc/init.d
  chown -R root.root /system/etc/init.d;
  chmod -R 755 /system/etc/init.d;
fi;
mount -o ro,remount /system;
