#!/bin/bash -e

install -v -d                                          "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d"
install -v -m 644 files/wait.conf                      "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/"

install -v -d                                          "${ROOTFS_DIR}/etc/wpa_supplicant"

install -d                                             "${ROOTFS_DIR}/rpicluster/network-manager"

install -v -m 600 files/wpa_supplicant.conf            "${ROOTFS_DIR}/etc/wpa_supplicant/"

install -m 755 files/link_wifi_adaptor.py              "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/enable-wifi.sh                    "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/disable-wifi.sh                   "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/enable-switch.sh                  "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/disable-switch.sh                 "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/startup.py                        "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/network-manager.py                "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/set-wifi.py                       "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 600 files/configured                        "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 777 files/.bash_aliases                     "${ROOTFS_DIR}/home/pi/"

on_chroot << EOF
sudo echo "sudo python /rpicluster/network-manager/startup.py" >> "${ROOTFS_DIR}/home/pi/"
EOF

# on_chroot << EOF
# echo "
# Generating new wpa_supplicant . . .
# "

# sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf

# sudo echo "network={
# ssid=\"CSLabs\"
# psk=\"1kudlick\"
# }" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant-wlan1.conf

# # echo "
# # Stopping host serices . . .
# # "

# # sudo systemctl stop dnsmasq
# # sudo systemctl stop hostapd


# echo "
# Updating dhcpcd.conf . . .
# "

# sudo echo "interface wlan0
# metric 150
# static ip_address=192.168.1.254/24
# #static routers=192.168.1.1
# #static domain_name_servers=192.168.1.1

# interface wlan1
# metric 100" | sudo tee -a /etc/dhcpcd.conf

# # echo "
# # Rebooting daemon and dhcpcd service . . .
# # "

# # sudo systemctl daemon-reload

# # sudo service dhcpcd restart

# echo "
# Generating new hostapd.conf . . .
# "

# sudo echo "interface=wlan0
# driver=nl80211
# ssid=rpicluster-AP
# channel=1
# wmm_enabled=0
# wpa=1
# wpa_passphrase=rpicluster
# wpa_key_mgmt=WPA-PSK
# wpa_pairwise=TKIP
# rsn_pairwise=CCMP
# auth_algs=1
# macaddr_acl=0
# logger_stdout=-1
# logger_stdout_level=2
# " | sudo tee /etc/hostapd/hostapd.conf

# echo "
# Linking new hostapd.conf . . .
# "

# sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

# sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd

# sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

# echo "
# Generating new dnsmasq.conf . . .
# "

# sudo echo "no-resolv
# interface=wlan0
# listen-address=192.168.1.254
# server=8.8.8.8 # Use Google DNS
# domain-needed # Don't forward short names
# bogus-priv # Drop the non-routed address spaces.
# dhcp-range=192.168.1.100,192.168.1.150,12h # IP range and lease time
# #log each DNS query as it passes through
# log-queries
# dhcp-authoritative
# " | sudo tee /etc/dnsmasq.conf

# echo "
# Allowing ip_forward . . .
# "

# sudo sed -i '28 s/#//' /etc/sysctl.conf

# sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

# echo "
# Updating rc.local . . .
# "

# sudo sed -i '20i\iptables-restore < /etc/iptables.ipv4.nat\' /etc/rc.local

# sudo sed -i '21i\sudo python /rpicluster/config/link_wifi_adaptor.py\' /etc/rc.local


# EOF
