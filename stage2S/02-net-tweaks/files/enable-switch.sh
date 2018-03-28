#!/bin/bash

echo "
Enabling Wifi-Ethernet_Switch networking scheme . . .
"

echo "
Generating new wpa_supplicant . . .
"

sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig

sudo python /rpicluster/network-manager/set-wifi.sh wpa_supplicant.conf

sudo service networking restart

echo "
Updating machine . . .
"
sudo apt-get update -y && sudo apt-get upgrade -y

echo "
Installing host services . . .
"
sudo apt-get install -y dnsmasq

echo "
Generating new iptable Rules . . .
"

sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE  
sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT 

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

echo "
Updating dhcpcd.conf . . .
"
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

sudo echo "interface eth0
static ip_address=192.168.1.254/24
#static routers=192.168.1.1
#static domain_name_servers=192.168.1.1
" | sudo tee -a /etc/dhcpcd.conf

# Remove default route created by dhcpcd
sudo ip route del 0/0 dev eth0 &> /dev/null


echo "
Stopping host serices . . .
"

sudo systemctl stop dnsmasq


echo "
Generating new dnsmasq.conf . . .
"
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo echo "no-resolv
interface=eth0
listen-address=192.168.1.254
server=8.8.8.8 # Use Google DNS
domain-needed # Don't forward short names
bogus-priv # Drop the non-routed address spaces.
dhcp-range=192.168.1.100,192.168.1.150,12h # IP range and lease time
#log each DNS query as it passes through
log-queries
dhcp-authoritative
" | sudo tee /etc/dnsmasq.conf


# cp /etc/dnsmasq.conf /run/dnsmasq/resolv.conf



echo "
Starting host serices . . .
"

sudo systemctl start dnsmasq

