#!/bin/bash -e

install -v -d						                    ${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d
install -v -m 644 files/wait.conf			            ${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/

install -v -d                                           ${ROOTFS_DIR}/etc/wpa_supplicant
install -v -m 600 files/wpa_supplicant.conf             ${ROOTFS_DIR}/etc/wpa_supplicant/




on_chroot << EOF

echo "node" > /etc/hostname
sudo sed -i '6s/.*/127.0.1.1       node/' /etc/hosts
sudo cp /etc/hosts /etc/hosts.orig

sudo sed -i '157 s/#//' /etc/locale.gen

sudo locale-gen en_US.UTF-8

sudo update-locale en_US.UTF-8

sudo echo "LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANGUAGE=en_US.UTF-8" >> /etc/default/locale

EOF
