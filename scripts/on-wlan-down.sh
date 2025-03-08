#!/bin/sh
echo "`date +"%Y-%m-%d %H:%M:%S"` - Stopping netbird service on turning off WiFi" >> /var/log/netbird/kobo-netbird.log
netbird down >> /var/log/netbird/kobo-netbird.log
netbird service stop >> /var/log/netbird/kobo-netbird.log
netbird service uninstall >> /var/log/netbird/kobo-netbird.log