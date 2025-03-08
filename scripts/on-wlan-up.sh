# #!/bin/sh
echo "`date +"%Y-%m-%d %H:%M:%S"` - Starting netbird service on turning on WiFi" >> /var/log/netbird/kobo-netbird.log

# Check if we're already trying to start netbird
LOCKFILE="/var/run/kobo-netbird.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
  echo "Lockfile found, already trying to start netbird. Exiting." >> /var/log/netbird/kobo-netbird.log
  exit 0
fi

# Wait until a network connection is established
while ! ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; do
  if ! ifconfig wlan0 >/dev/null 2>&1; then
    echo "WiFi turned on down while waiting for a connection. Exiting." >> /var/log/netbird/kobo-netbird.log
    exit 0
  fi
  sleep 2
done

# Set PATH to include /usr/sbin and /usr/bin so netbird can use uname and other
# commands, without which it will fail to start
export PATH=/usr/sbin:/usr/bin:$PATH

netbird service install >> /var/log/netbird/kobo-netbird.log
netbird service start >> /var/log/netbird/kobo-netbird.log
netbird up >> /var/log/netbird/kobo-netbird.log