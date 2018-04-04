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

install -m 755 files/status.py                         "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/set-wifi.sh                       "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 600 files/configured                        "${ROOTFS_DIR}/rpicluster/network-manager/"

on_chroot << EOF
sudo echo "sudo python /rpicluster/network-manager/startup.py" >> /home/pi/.profile
sudo echo "rpicluster" > /etc/hostname
sudo sed -i '6s/.*/127.0.1.1       rpicluster/' /etc/hosts

sudo apt-get install -y hostapd

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

sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd

sudo sed -i '35s/.*/StrictHostKeyChecking no/' /etc/ssh/ssh_config

sudo sed -i '36s/.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

EOF
