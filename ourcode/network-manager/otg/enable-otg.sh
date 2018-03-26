#!/bin/bash

echo "
Enabling Wifi-OTG networking scheme . . .
"

echo "
Generating new wpa_supplicant . . .
"

sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig

sudo echo "network={
ssid=\"CSLabs\"
psk=\"1kudlick\"
}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf

sleep 1

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
sudo iptables -A FORWARD -i wlan0 -o usb0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i usb0 -o wlan0 -j ACCEPT 
sudo iptables -A FORWARD -i wlan0 -o usb1 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i usb1 -o wlan0 -j ACCEPT 
sudo iptables -A FORWARD -i wlan0 -o usb2 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i usb2 -o wlan0 -j ACCEPT 
sudo iptables -A FORWARD -i wlan0 -o usb3 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i usb3 -o wlan0 -j ACCEPT 

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

echo "
Updating dhcpcd.conf . . .
"
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

sudo echo "interface usb0
static ip_address=192.168.1.250/24
static domain_name_servers=8.8.8.8

interface usb1
static ip_address=192.168.1.251/24
static domain_name_servers=8.8.8.8

interface usb2
static ip_address=192.168.1.252/24
static domain_name_servers=8.8.8.8

interface usb3
static ip_address=192.168.1.253/24
static domain_name_servers=8.8.8.8
" | sudo tee -a /etc/dhcpcd.conf


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


cp /etc/dnsmasq.conf /run/dnsmasq/resolv.conf



echo "
Starting host serices . . .
"

sudo systemctl start dnsmasq


echo "
Getting Tired . . Time to reboot . . .
"
sleep 1

sudo reboot -h now
