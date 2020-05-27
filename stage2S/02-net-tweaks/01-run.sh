#!/bin/bash -e

install -d                                             "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d"

install -m 644 files/wait.conf                         "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/"

install -d                                             "${ROOTFS_DIR}/etc/wpa_supplicant"

install -d                                             "${ROOTFS_DIR}/rpicluster/network-manager"

install -m 600 files/wpa_supplicant.conf               "${ROOTFS_DIR}/etc/wpa_supplicant/"

install -m 755 files/link_wifi_adaptor.py              "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/enable-wifi.sh                    "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/disable-wifi.sh                   "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/enable-switch.sh                  "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/disable-switch.sh                 "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/enable-base.sh                    "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/disable-base.sh                   "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/startup-profile.py                "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/network-manager.py                "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/status.py                         "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/set-wifi.sh                       "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/configured                        "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/nodes                             "${ROOTFS_DIR}/rpicluster/config/"


on_chroot << EOF

sudo echo "rpicluster" > /etc/hostname

sudo sed -i '6s/.*/127.0.1.1       rpicluster/' /etc/hosts

sudo bash /rpicluster/network-manager/enable-base.sh

sudo sed -i '35s/.*/StrictHostKeyChecking no/' /etc/ssh/ssh_config

sudo sed -i '36s/.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

sudo sed -i '37s/.*/LogLevel ERROR/' /etc/ssh/ssh_config

sudo sed -i '157 s/#//' /etc/locale.gen

sudo locale-gen en_US.UTF-8

sudo update-locale en_US.UTF-8

sudo cp /etc/hosts /etc/hosts.orig

sudo echo "LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANGUAGE=en_US.UTF-8" >> /etc/default/locale

EOF
