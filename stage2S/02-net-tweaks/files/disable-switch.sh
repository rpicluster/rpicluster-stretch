#!/bin/bash

echo "
Disabling Wifi-Ethernet_Switch networking scheme . . .
"

echo "
Restoring wpa_supplicant.conf . . .
"

sudo rm /etc/wpa_supplicant.conf
sudo mv /etc/wpa_supplicant.conf.orig /etc/wpa_supplicant.conf



echo "
Restoring dhcpcd.conf . . .
"
sudo rm /etc/dhcpcd.conf
sudo mv /etc/dhcpcd.conf.orig /etc/dhcpcd.conf



echo "
Restoring dnsmasq.conf . . .
"

sudo rm /etc/dnsmasq.conf
sudo mv /etc/dnsmasq.conf.orig /etc/dnsmasq.conf


# TO-DO: WTF DO I DO ABOUT THE RESOLV CONFGI RESTORATION 
# cp /etc/dnsmasq.conf /run/dnsmasq/resolv.conf

