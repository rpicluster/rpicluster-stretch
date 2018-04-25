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

install -m 755 files/enable-base.sh                    "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/disable-base.sh                   "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/startup-profile.py                        "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/network-manager.py                "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/status.py                         "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/set-wifi.sh                       "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 600 files/configured                        "${ROOTFS_DIR}/rpicluster/network-manager/"

install -m 755 files/nodes                             "${ROOTFS_DIR}/rpicluster/config/"


on_chroot << EOF

sudo echo "rpicluster" > /etc/hostname

sudo sed -i '6s/.*/127.0.1.1       rpicluster/' /etc/hosts

sudo bash /rpicluster/network-manager/enable-base.sh

sudo sed -i '35s/.*/StrictHostKeyChecking no/' /etc/ssh/ssh_config

sudo sed -i '36s/.*/UserKnownHostsFile \/dev\/null/' /etc/ssh/ssh_config

sudo sed -i '37s/.*/LogLevel QUIET' /etc/ssh/ssh_config

sudo cp /etc/hosts /etc/hosts.orig


EOF
