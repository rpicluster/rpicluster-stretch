
echo "
Disabling Wifi-Wifi networking scheme . . .
"
echo "
removing wlan1 wpa_supplicant . . .
"
sudo rm /etc/wpa_supplicant/wpa_supplicant-wlan1.conf

echo "
Stopping hostapd . . .
"
sudo systemctl stop hostapd


echo "
Restoring dhcpcd.conf . . .
"
sudo rm /etc/dhcpcd.conf
sudo mv /etc/dhcpcd.conf.orig /etc/dhcpcd.conf

echo "
Rebooting daemon and dhcpcd service . . .
"

sudo systemctl daemon-reload

sudo service dhcpcd restart

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

echo "
Restoring rc.local . . .
"

sed -i '21d' /etc/rc.local
sed -i '22d' /etc/rc.local

echo "
Getting Tired . . Time to reboot . . .
"
sleep 1

sudo reboot -h now
