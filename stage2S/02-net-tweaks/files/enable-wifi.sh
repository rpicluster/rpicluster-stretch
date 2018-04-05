#!/bin/bash

echo "
Enabling Wifi-Wifi networking scheme . . .
"

echo "
Generating new wpa_supplicant . . .
"

sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf

sudo bash /rpicluster/network-manager/set-wifi.sh wpa_supplicant-wlan1.conf

echo "
Installing host services . . .
"
sudo apt-get install -y dnsmasq
sudo apt-get install -y hostapd
sudo apt-get install -y rng-tools

# echo "
# Stopping host serices . . .
# "

# sudo systemctl stop dnsmasq
# sudo systemctl stop hostapd


echo "
Updating dhcpcd.conf . . .
"
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

sudo echo "interface wlan0
metric 150
static ip_address=192.168.1.254/24
#static routers=192.168.1.1
static domain_name_servers=8.8.8.8 #192.168.1.1

interface wlan1
metric 100" | sudo tee -a /etc/dhcpcd.conf

# echo "
# Rebooting daemon and dhcpcd service . . .
# "

# sudo systemctl daemon-reload

# sudo service dhcpcd restart

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


echo "
Generating new dnsmasq.conf . . .
"
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo echo "no-resolv
interface=wlan0
listen-address=192.168.1.254
server=8.8.8.8 # Use Google DNS
domain-needed # Don't forward short names
bogus-priv # Drop the non-routed address spaces.
dhcp-range=192.168.1.100,192.168.1.150,12h # IP range and lease time
#log each DNS query as it passes through
log-queries
dhcp-authoritative
" | sudo tee /etc/dnsmasq.conf


echo "
Generating new iptable Rules . . .
"

sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE 
sudo iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT

echo "
Allowing ip_forward . . .
"

sudo sed -i '28 s/#//' /etc/sysctl.conf

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

echo "
Updating startup activities . . .
"
sudo echo "sudo python /rpicluster/network-manager/link_wifi_adaptor.py" | sudo tee -a /home/pi/.profile

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

sudo sed -i '20i\iptables-restore < \/etc\/iptables.ipv4.nat\' /etc/rc.local

# echo "
# Starting host services . . .
# "

# sudo systemctl start dnsmasq
# sudo systemctl start hostapd


