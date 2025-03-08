#!/bin/sh

# Make sure to load the TUN kernel module and create the /dev/net/tun device
if [ ! -c /dev/net/tun ]; then

  if [ -f /lib/modules/netbird/kernel/drivers/net/tun.ko ]; then
    insmod /lib/modules/netbird/kernel/drivers/net/tun.ko
  fi

  mkdir -p /dev/net
  mknod /dev/net/tun c 10 200
fi

# Make sure /mnt/onboard is mounted
timeout 5 sh -c "while ! grep -q /mnt/onboard /proc/mounts; do sleep 0.1; done"
if [[ $? -eq 143 ]]; then
    exit 1
fi

# Set PATH to include /usr/sbin and /usr/bin so netbird can use uname and other
# commands, without which it will fail to start
export PATH=/usr/sbin:/usr/bin:$PATH

# Ensure /var/log/netbird exists and /var/log isn't mounted to be too small,
# without which netbird will fail to start
mkdir -p /var/log/netbird
echo "`date +"%Y-%m-%d %H:%M:%S"` - Preparing netbird log directory on boot" >> /var/log/netbird/kobo-netbird.log
min_log_dir_size=1024
current_log_dir_size=$(df -k /var/log | awk 'NR==2 {print $2}')
if [ "$current_log_dir_size" -lt "$min_log_dir_size" ]; then
  mount -o remount,size=10M /var/log
fi

if [ "$(pidof netbird | wc -w)" -eq 0 ]; then
    echo "`date +"%Y-%m-%d %H:%M:%S"` - Starting netbird service on boot" >> /var/log/netbird/kobo-netbird.log
    netbird service install >> /var/log/netbird/kobo-netbird.log
    netbird service start >> /var/log/netbird/kobo-netbird.log
fi

exit 0
