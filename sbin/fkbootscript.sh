#!/system/bin/sh

# disable sysctl.conf to prevent ROM interference with tunables
# backup and replace PowerHAL with custom build to allow OC/UC to survive screen off
# create and set permissions for /system/etc/init.d if it doesn't already exist
mount -o rw,remount /system;
[ -e /system/etc/sysctl.conf ] && mv /system/etc/sysctl.conf /system/etc/sysctl.conf.fkbak;
[ -f /system/bin/thermal-engine-hh-bak ] || mv /system/bin/thermal-engine-hh /system/bin/thermal-engine-hh-bak
if [ ! -e /system/etc/init.d ]; then
  mkdir /system/etc/init.d
  chown -R root.root /system/etc/init.d;
  chmod -R 755 /system/etc/init.d;
fi;
mount -o ro,remount /system;

echo 90 1574400:90 1958400:99 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
