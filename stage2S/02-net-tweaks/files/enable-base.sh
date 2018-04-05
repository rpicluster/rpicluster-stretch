#!/bin/bash -e

echo "
Enabling Base networking scheme . . .
"


echo "
Updating dhcpcd.conf . . .
"
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

sudo echo "interface wlan0
metric 150
static ip_address=192.168.1.254/24
#static routers=192.168.1.1
static domain_name_servers=8.8.8.8" | sudo tee -a /etc/dhcpcd.conf




echo "
Generating new hostapd.conf . . .
"

sudo echo "interface=wlan0
driver=nl80211
ssid=rpicluster-AP
channel=1
wmm_enabled=0
wpa=1
wpa_passphrase=rpicluster
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
auth_algs=1
macaddr_acl=0
logger_stdout=-1
logger_stdout_level=2
" | sudo tee /etc/hostapd/hostapd.conf



echo "
Linking new hostapd.conf . . .
"

sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd
