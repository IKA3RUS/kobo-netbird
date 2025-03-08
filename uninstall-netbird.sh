#!/bin/sh

pid=$(pgrep netbird)
if [ -n "$pid" ]; then
  echo "Stopping netbird..."
  kill -15 "$pid"

  # Wait a little bit for the daemon to terminate cleanly.
  sleep 3
fi

if command -v netbird >/dev/null 2>&1 && [ -f /etc/init.d/netbird ]; then
  echo "Removing netbird service..."
  netbird service stop > /dev/null
  netbird service uninstall > /dev/null
fi

echo "Removing netbird..."
rm -rf /mnt/onboard/netbird
rm -f /usr/bin/netbird

echo "Removing netbird load scripts..."
rm -rf /usr/local/netbird

echo "Removing netbird udev rules..."
rm -f /etc/udev/rules.d/777-netbird.rules

echo "Removing netbird configs and logs..."
rm -rf /etc/netbird /var/lib/netbird /var/log/netbird /var/run/netbird.sock /var/run/netbird.pid /var/run/kobo-netbird.lock

if [ -f /lib/modules/netbird/kernel/drivers/net/tun.ko ]; then
  echo "Removing TUN drivers..."
  rm -f /lib/modules/netbird/kernel/drivers/net/tun.ko
fi

echo "Removing nftables..."
rm -f /sbin/nft
rm -f /lib/libgmp.so.10 /lib/libjansson.so.4 /lib/libmnl.so.0 /lib/libnftnl.so.11 /lib/libxtables.so.12

echo "Uninstalled netbird successfully!"
