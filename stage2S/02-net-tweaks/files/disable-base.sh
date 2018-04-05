#!/bin/bash -e


echo "
Disabling Base networking scheme . . .
"

echo "
Restoring dhcpcd.conf . . .
"
sudo rm /etc/dhcpcd.conf
sudo mv /etc/dhcpcd.conf.orig /etc/dhcpcd.conf


echo "
Removing hostapd.conf . . .
"
sudo rm /etc/hostapd/hostapd.conf


echo "
Unlinking hostapd.conf . . .
"

sudo sed -i '10s/.*/#DAEMON_CONF=""/' /etc/default/hostapd

sudo sed -i '19s/.*/#DAEMON_CONF=/' /etc/init.d/hostapd

echo "
Restoring dnsmasq.conf . . .
"

sudo rm /etc/dnsmasq.conf
sudo mv /etc/dnsmasq.conf.orig /etc/dnsmasq.conf
