#!/bin/bash -e

install -v -d						                    ${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d
install -v -m 644 files/wait.conf			            ${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/

install -v -d                                           ${ROOTFS_DIR}/etc/wpa_supplicant
install -v -m 600 files/wpa_supplicant.conf             ${ROOTFS_DIR}/etc/wpa_supplicant/




on_chroot << EOF

sudo echo "network={
ssid=\"rpicluster-AP\"
psk=\"rpicluster\"
}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf

echo "node" > /etc/hostname
sudo sed -i '6s/.*/127.0.1.1       node/' /etc/hosts
sudo cp /etc/hosts /etc/hosts.orig
EOF
