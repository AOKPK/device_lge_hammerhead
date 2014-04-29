#!/system/bin/sh

# Script to launch frandom at boot by Ryuinferno @ XDA 
chmod 644 /dev/frandom
chmod 644 /dev/erandom
mv /dev/random /dev/random.ori
mv /dev/urandom /dev/urandom.ori
ln /dev/frandom /dev/random
chmod 644 /dev/random
ln /dev/erandom /dev/urandom
chmod 644 /dev/urandom 

# disable sysctl.conf to prevent ROM interference with tunables
# backup and replace PowerHAL with custom build to allow OC/UC to survive screen off
# create and set permissions for /system/etc/init.d if it doesn't already exist
mount -o rw,remount /system /system;
[ -e /system/etc/sysctl.conf ] && mv /system/etc/sysctl.conf /system/etc/sysctl.conf.fkbak;
[ -f /system/lib/hw/power.msm8974.so.bak ] || mv /system/lib/hw/power.msm8974.so /system/lib/hw/power.msm8974.so.bak
[ -f /system/bin/thermal-engine-hh-bak ] || mv /system/bin/thermal-engine-hh /system/bin/thermal-engine-hh-bak

if [ ! -e /system/etc/init.d ]; then
  mkdir /system/etc/init.d
  chown -R root.root /system/etc/init.d;
  chmod -R 755 /system/etc/init.d;
fi;
mount -o ro,remount /system /system;

echo 85 1500000:90 1800000:70 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 20000 1400000:40000 1700000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay

echo 2 > /sys/devices/system/cpu/sched_mc_power_savings

# wait for systemui and increase its priority
while sleep 1; do
  if [ `$bb pidof com.android.systemui` ]; then
    systemui=`$bb pidof com.android.systemui`;
    $bb renice -18 $systemui;
    $bb echo -17 > /proc/$systemui/oom_adj;
    $bb chmod 100 /proc/$systemui/oom_adj;
    exit;
  fi;
done&

# lmk whitelist for common launchers and increase launcher priority
list="com.android.launcher com.google.android.googlequicksearchbox org.adw.launcher org.adwfreak.launcher net.alamoapps.launcher com.anddoes.launcher com.android.lmt com.chrislacy.actionlauncher.pro com.cyanogenmod.trebuchet com.gau.go.launcherex com.gtp.nextlauncher com.miui.mihome2 com.mobint.hololauncher com.mobint.hololauncher.hd com.qihoo360.launcher com.teslacoilsw.launcher com.tsf.shell org.zeam";
while sleep 60; do
  for class in $list; do
    if [ `$bb pgrep $class | head -n 1` ]; then
      launcher=`$bb pgrep $class`;
      $bb echo -17 > /proc/$launcher/oom_adj;
      $bb chmod 100 /proc/$launcher/oom_adj;
      $bb renice -18 $launcher;
    fi;
  done;
  exit;
done&

# kecinzer tunables

fstrim -v /cache;
fstrim -v /data; 

echo "20" > /proc/sys/vm/dirty_background_ratio
echo "40" > /proc/sys/vm/dirty_ratio
echo "1000" > /proc/sys/vm/dirty_writeback_centisecs
echo "500" > /proc/sys/vm/dirty_expire_centisecis