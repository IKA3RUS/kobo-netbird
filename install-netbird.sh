#!/bin/sh

set -e

export NETBIRD_VERSION=0.37.2
# If you want the latest netbird version and can handle potential errors,
#   uncomment the following line
# export NETBIRD_VERSION=$(wget -qO- https://api.github.com/repos/netbirdio/netbird/releases/latest | awk -F'"' '/tag_name/ {print substr($4,2)}')

echo
echo "Installing netbird ${NETBIRD_VERSION} for your Kobo!"
uname -a
echo

echo "Downloading netbird..."
mkdir netbird_${NETBIRD_VERSION}_linux_armv6
wget -P netbird_${NETBIRD_VERSION}_linux_armv6 \
  https://github.com/netbirdio/netbird/releases/download/v${NETBIRD_VERSION}/netbird_${NETBIRD_VERSION}_linux_armv6.tar.gz
tar -xvf netbird_${NETBIRD_VERSION}_linux_armv6/netbird_${NETBIRD_VERSION}_linux_armv6.tar.gz -C ./netbird_${NETBIRD_VERSION}_linux_armv6 > /dev/null

echo "Installing netbird..."
mkdir -p /mnt/onboard/netbird
mv netbird_${NETBIRD_VERSION}_linux_armv6/netbird /mnt/onboard/netbird

# Symlink netbird binary to /usr/bin
ln -sf /mnt/onboard/netbird/netbird /usr/bin/netbird

echo "Cleaning up netbird installation files..."
rm -rf netbird_${NETBIRD_VERSION}_linux_armv6

echo "Installing netbird load scripts..."
mkdir -p /usr/local/netbird
cp scripts/* /usr/local/netbird

if ! lsmod | grep -q "^tun" && [ ! -c /dev/net/tun ]; then
  echo "Installing TUN drivers..."
  mkdir -p /lib/modules/netbird/kernel/drivers/net
  cp modules/tun.ko /lib/modules/netbird/kernel/drivers/net/tun.ko
fi

echo "Installing nftables v0.9.0..."

cp binaries/nftables/sbin/* /sbin
cp binaries/nftables/lib/* /lib

ln -sf /lib/libgmp.so.10.3.2 /lib/libgmp.so.10
ln -sf /lib/libjansson.so.4.11.1 /lib/libjansson.so.4
ln -sf /lib/libmnl.so.0.2.0 /lib/libmnl.so.0
ln -sf /lib/libnftnl.so.11.0.0 /lib/libnftnl.so.11
ln -sf /lib/libxtables.so.12.2.0 /lib/libxtables.so.12

echo "Installing latest CA certificates..."
# This lets selfhosted netbird setups with Let's Encrypt SSL certificates work
mkdir -p /etc/ssl/certs
wget https://curl.se/ca/cacert.pem -O /etc/ssl/certs/ca-certificates.crt

echo "Installing netbird udev rules..."
cp rules/* /etc/udev/rules.d

echo "Preparing netbird log directory..."
mkdir -p /var/log/netbird
# Ensure /var/log is mounted with atleast 1MB size
min_log_dir_size=1024
current_log_dir_size=$(df -k /var/log | awk 'NR==2 {print $2}')
if [ "$current_log_dir_size" -lt "$min_log_dir_size" ]; then
  mount -o remount,size=10M /var/log
fi

echo "Installation netbird successfully! Initializing netbird now..."
/usr/local/netbird/boot.sh

echo
echo "If no errors were reported, netbird should be installed and initialized!"
echo "You can now configure netbird by running 'netbird up' and following the instructions."
echo
