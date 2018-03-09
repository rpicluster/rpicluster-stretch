#PREDICTABLE NETWORK NAMES FIX
#NA


#DO THIS STUFF BEFORE INSTALLING SCRIPT
# sudo apt-get update -y && sudo apt-get upgrade -y


# sudo apt-get install -y dnsmasq
# sudo apt-get install -y hostapd
# sudo apt-get install -y rng-tools

# sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlx28f366aa5a6f.conf

# sudo echo "network={
#         ssid=\"CSLabs\"
#         psk=\"1kudlick\"
# }" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant-wlx28f366aa5a6f.conf


echo "Generating new iptable Rules . . . 
"
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlx28f366aa5a6f -j MASQUERADE
sudo iptables -A FORWARD -i wlx28f366aa5a6f -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o wlx28f366aa5a6f -j ACCEPT
# ---------------------------------------------------------------
echo "Allowing ip_forward . . . 
"
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

sudo ifconfig wlan0 192.168.2.1 netmask 255.255.255.0

sudo ip route del 0/0 dev wlan0 &> /dev/null

echo "Stopping host serices . . . 
"

sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

echo "Generating new hostapd.conf . . . 
"

sudo echo "interface=wlan0
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
logger_stdout=-1
logger_stdout_level=2
" | sudo tee /etc/hostapd/hostapd.conf

echo "Linking new hostapd.conf . . . 
"

sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd

echo "Generating new dnsmasq.conf . . . 
"

echo -e "interface=wlan0\n\
bind-interfaces\n\
server=8.8.8.8\n\
domain-needed\n\
bogus-priv\n\
dhcp-range=192.168.2.2,192.168.2.100,12h" > /etc/dnsmasq.conf

echo "Starting host services . . . 
"

cp /etc/dnsmasq.conf /run/dnsmasq/resolv.conf

sudo systemctl daemon-reload

sudo systemctl start dnsmasq
sudo systemctl start hostapd


# sudo sed -i '20i\sudo bash /run.sh\' /etc/rc.local

# sudo service hostapd status

# #DEBUG --->>>
# sudo hostapd -dd /etc/hostapd/hostapd.conf



