#PREDICTABLE NETWORK NAMES FIX
#"net.ifnames=1" to the end of cmdline.txt

sudo apt-get update -y && sudo apt-get upgrade -y

#https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=206784
#derek ur retarted do as he does

sudo apt-get install -y hostapd
sudo apt-get install -y dnsmasq
sudo apt-get install -y rng-tools
#status RNG
#sudo service rng-tools status

sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlx28f366aa5a6f.conf

sudo echo "network={
        ssid=\"CSLabs\"
        psk=\"1kudlick\"
}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant-wlx28f366aa5a6f.conf

sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

# IF BUILT IN IS ON WLAN0 THEN SWAP WLAN1 FOR WLAN0 
# builtin MUST be the access point as dongle needs AP Mode
# ENDING MAC FOR DONGLE = ...:6f
#ADDED IN DENYINTERFACES FOR AP INTERFACE
#ADDED IN STATIC DOMAIN_NAME_SERVERS
#CHANGED IPS FROM 220.x to 1.x
#SPECIFYING ip/24 TAKES PLACE OF HAVING TO SPECIFY THE NETMASK netmask=255.255.255.0
sudo echo "denyinterfaces wlan0
interface wlan0
static ip_address=192.168.1.15/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1" | sudo tee -a /etc/dhcpcd.conf

sudo systemctl daemon-reload

sudo service dhcpcd restart

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
" | sudo tee /etc/hostapd/hostapd.conf

sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo echo "interface=wlan0  
listen-address=192.168.1.15
server=8.8.8.8       # Use Google DNS  
domain-needed        # Don't forward short names  
bogus-priv           # Drop the non-routed address spaces.  
dhcp-range=192.168.1.50,192.168.1.150,12h # IP range and lease time " | sudo tee /etc/dnsmasq.conf

# IPTABLES: ------------------------------------------
sudo iptables -X
sudo iptables -F
sudo iptables -t nat -X
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlx28f366aa5a6f -j MASQUERADE
sudo iptables -A FORWARD -i wlx28f366aa5a6f -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o wlx28f366aa5a6f -j ACCEPT
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

sudo systemctl daemon-reload

sudo systemctl start hostapd
sudo systemctl start dnsmasq

sudo reboot -h now

# sudo service hostapd status

# #DEBUG --->>>
# sudo hostapd -dd /etc/hostapd/hostapd.conf



