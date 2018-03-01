#!/bin/bash -e

on_chroot << EOF

ip_address="192.168.0.254"
netmask="255.255.255.0"
dhcp_range_start="192.168.0.1"
dhcp_range_end="192.168.0.100"
dhcp_time="12h"
eth="eth0"
wlan="wlan0"

sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o $wlan -j MASQUERADE  
sudo iptables -A FORWARD -i $wlan -o $eth -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i $eth -o $wlan -j ACCEPT 

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo ifconfig $eth $ip_address netmask $netmask

# Remove default route created by dhcpcd
sudo ip route del 0/0 dev $eth &> /dev/null

sudo systemctl stop dnsmasq

sudo chmod 770 /etc/dnsmasq.conf

sudo echo -e "interface=$eth\n\
bind-interfaces\n\
server=8.8.8.8\n\
domain-needed\n\
bogus-priv\n\
dhcp-range=$dhcp_range_start,$dhcp_range_end,$dhcp_time" > /etc/dnsmasq.conf

# This file will work if resolveconf package is installed
# Due to new updates in dnsmasq
sudo cp /etc/dnsmasq.conf /run/dnsmasq/resolv.conf

sudo systemctl start dnsmasq

EOF
