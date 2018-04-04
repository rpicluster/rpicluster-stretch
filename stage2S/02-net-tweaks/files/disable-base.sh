#!/bin/bash -e


echo "
Disabling Base networking scheme . . .
"

echo "
Removing hostapd.conf . . .
"
sudo rm /etc/hostapd/hostapd.conf


echo "
Unlinking hostapd.conf . . .
"

sudo sed -i '10s/.*/#DAEMON_CONF=""/' /etc/default/hostapd

sudo sed -i '19s/.*/#DAEMON_CONF=/' /etc/init.d/hostapd

