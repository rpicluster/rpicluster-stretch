#PREDICTABLE NETWORK NAMES FIX
#NA

echo "Updating machine . . . 
"

sudo apt-get update -y && sudo apt-get upgrade -y

#https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=206784

echo "Installing host services . . . 
"
sudo apt-get install -y dnsmasq
sudo apt-get install -y hostapd
sudo apt-get install -y rng-tools

#sudo service rng-tools status

echo "Generating new wpa_supplicant . . . 
"

sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlx28f366aa5a6f.conf

sudo echo "network={
        ssid=\"CSLabs\"
        psk=\"1kudlick\"
}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant-wlx28f366aa5a6f.conf

echo "Stopping host serices . . . 
"

sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

# IF BUILT IN IS ON WLAN0 THEN SWAP WLAN1 FOR WLAN0 
# builtin MUST be the access point as dongle needs AP Mode
# ENDING MAC FOR DONGLE = ...:6f
#MAY NEED DENYINTERFACES FOR AP INTERFACE denyinterfaces wlan0
#ADDED IN STATIC DOMAIN_NAME_SERVERS
#CHANGED IPS FROM 220.x to 1.x
#SPECIFYING ip/24 TAKES PLACE OF HAVING TO SPECIFY THE NETMASK netmask=255.255.255.0

#-----------------------------------------------------------
echo "Updating dhcpcd.conf . . . 
"

sudo echo "interface wlan0
static ip_address=192.168.1.15/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1" | sudo tee -a /etc/dhcpcd.conf

echo "Rebooting daemon and dhcpcd service . . . 
"

sudo systemctl daemon-reload

sudo service dhcpcd restart
#------------------------------------------------------------

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

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

echo "Generating new dnsmasq.conf . . . 
"

sudo echo "no-resolv #potentially needed
interface=wlan0  
listen-address=192.168.1.15
server=8.8.8.8       # Use Google DNS  
domain-needed        # Don't forward short names  
bogus-priv           # Drop the non-routed address spaces.  
dhcp-range=192.168.1.50,192.168.1.150,12h # IP range and lease time
#log each DNS query as it passes through
log-queries
dhcp-authoritative
" | sudo tee /etc/dnsmasq.conf

# IPTABLES: ------------------------------------------
echo "Generating new iptable Rules . . . 
"
IPTABLES="$(which iptables)"
# RESET DEFAULT POLICIES
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT
$IPTABLES -t mangle -P PREROUTING ACCEPT
$IPTABLES -t mangle -P OUTPUT ACCEPT
# FLUSH ALL RULES, ERASE NON-DEFAULT CHAINS
$IPTABLES -F
$IPTABLES -X
$IPTABLES -t nat -F
$IPTABLES -t nat -X
$IPTABLES -t mangle -F
$IPTABLES -t mangle -X
sudo iptables -t nat -A POSTROUTING -o wlx28f366aa5a6f -j MASQUERADE #--source 192.168.1.15
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE #--source 10.10.34.18
sudo iptables -A FORWARD -i wlx28f366aa5a6f -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o wlx28f366aa5a6f -j ACCEPT
# -----------------------------------------------------------------
#  IPT=/sbin/iptables
#  LOCAL_IFACE=wlan0
#  INET_IFACE=wlx28f366aa5a6f
#  INET_ADDRESS=10.10.34.18
# # Flush the tables
#  $IPT -F INPUT
#  $IPT -F OUTPUT
#  $IPT -F FORWARD
# $IPT -t nat -P PREROUTING ACCEPT
#  $IPT -t nat -P POSTROUTING ACCEPT
#  $IPT -t nat -P OUTPUT ACCEPT
# # Allow forwarding packets:
#  $IPT -A FORWARD -p ALL -i $LOCAL_IFACE -o $INET_IFACE -j ACCEPT
#  $IPT -A FORWARD -i $INET_IFACE -o $LOCAL_IFACE -m state --state ESTABLISHED,RELATED -j ACCEPT
# # Packet masquerading
#  $IPT -t nat -A POSTROUTING -o $LOCAL_IFACE -j MASQUERADE
#  $IPT -t nat -A POSTROUTING -o $INET_IFACE -j SNAT --to-source $INET_ADDRESS
# -----------------------------------------------------------------

echo "Allowing ip_forward . . . 
"

sudo sed -i '28 s/#//' /etc/sysctl.conf

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

echo "Saving / Restoring iptables . . . 
"

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

sudo sed -i '20i\iptables-restore < /etc/iptables.ipv4.nat\' /etc/rc.local

echo "Starting host services . . . 
"

sudo systemctl daemon-reload

sudo systemctl start dnsmasq
sudo systemctl start hostapd

echo "Getting Tired . . Time to reboot . . . 
"
sleep 5

sudo reboot -h now

# sudo service hostapd status

# #DEBUG --->>>
# sudo hostapd -dd /etc/hostapd/hostapd.conf



