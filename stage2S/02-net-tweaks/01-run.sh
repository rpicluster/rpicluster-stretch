#!/bin/bash -e

install -v -d						${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d
install -v -m 644 files/wait.conf			${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/

install -v -d                                           ${ROOTFS_DIR}/etc/wpa_supplicant
install -v -m 600 files/wpa_supplicant.conf             ${ROOTFS_DIR}/etc/wpa_supplicant/

install -v -m 600 files/interfaces    ${ROOTFS_DIR}/etc/network/interfaces


on_chroot << EOF
cd /etc
sudo mv dnsmasq.conf dnsmasq.default
sudo apt-get update && sudo apt-get upgrade -y
echo "interface=eth0
listen-address=192.168.0.254 # listen on
# Bind to the interface to make sure we aren't sending things
# elsewhere
bind-interfaces
server=8.8.8.8 # Forward DNS requests to Google DNS
domain-needed # Don't forward short names
# Never forward addresses in the non-routed address spaces.
bogus-priv
# Assign IP addresses between 192.168.0.1 and 192.168.0.100 with a
# 12 hours lease time 
dhcp-range=192.168.0.126,192.168.0.253,12h" > dnsmasq.conf
sed -i '28 s/#//' sysctl.conf
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sed -i '20i\iptables-restore < /etc/iptables.ipv4.nat\' rc.local
cd -
EOF
