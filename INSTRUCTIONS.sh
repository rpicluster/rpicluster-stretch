sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install -y hostapd
sudo apt-get install -y dnsmasq

sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

sudo echo "network={
        ssid=\"CSLabs\"
        psk=\"1kudlick\"
}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

# IF BUILT IN IS ON WLAN0 THEN SWAP WLAN1 FOR WLAN0

sudo echo "interface wlan1
static ip_address=192.168.220.1/24
static routers=192.168.220.0" | sudo tee -a /etc/dhcpcd.conf

sudo systemctl daemon-reload

sudo service dhcpcd restart

sudo echo "interface=wlan1
driver=nl80211
ssid=Pi-AP
channel=1
wmm_enabled=0
wpa=1
wpa_passphrase=raspberry
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
auth_algs=1
macaddr_acl=0
" | sudo tee /etc/hostapd/hostapd.conf

sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo echo "interface=wlan1  
listen-address=192.168.220.1
server=8.8.8.8       # Use Google DNS  
domain-needed        # Don't forward short names  
bogus-priv           # Drop the non-routed address spaces.  
dhcp-range=192.168.220.50,192.168.220.150,12h # IP range and lease time " | sudo tee /etc/dnsmasq.conf

# IPTABLES: ------------------------------------------
sudo iptables -X
sudo iptables -F
sudo iptables -t nat -X
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o wlan1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan1 -o wlan0 -j ACCEPT
# -----------------------------------------------------------------
# sudo iptables -X
# sudo iptables -F
# sudo iptables -t nat -X
# sudo iptables -t nat -F
# sudo iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo iptables -t nat -I POSTROUTING -o wlan0 -j MASQUERADE
# -----------------------------------------------------------------

sudo sed -i '28 s/#//' /etc/sysctl.conf

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

sudo sed -i '20i\iptables-restore < /etc/iptables.ipv4.nat\' /etc/rc.local

sudo systemctl start hostapd
sudo systemctl start dnsmasq

sudo reboot -h now

# sudo service hostapd status

# #DEBUG --->>>
# sudo hostapd -dd /etc/hostapd/hostapd.conf



