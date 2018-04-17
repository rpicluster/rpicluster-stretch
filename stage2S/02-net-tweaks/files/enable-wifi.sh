#!/bin/bash


echo "
Enabling Wifi-Wifi networking scheme . . .
"

count=0
total=9
start=`date +%s`

while [ $count -eq $total ]; do
    cur=`date +%s`

    if [ $count -eq 0 ]
    	then

    	task = "Configuring Wifi Adaptor"
    	sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf
		sudo bash /rpicluster/network-manager/set-wifi.sh wpa_supplicant-wlan1.conf
		sudo python /rpicluster/network-manager/link_wifi_adaptor.py wlan1
		echo " "

	elif [ $count -eq 1 ]
		then

		task = "Installing host services"
		sudo apt-get install -y dnsmasq &> /dev/null
		sudo apt-get install -y hostapd &> /dev/null
		sudo apt-get install -y rng-tools &> /dev/null
	elif [ $count -eq 2 ] 
		then


		task = "Updating dhcpcd.conf"
		sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

		sudo echo "interface wlan0
metric 150
static ip_address=192.168.1.254/24
#static routers=192.168.1.1
static domain_name_servers=8.8.8.8 #192.168.1.1

interface wlan1
metric 100" >> /etc/dhcpcd.conf
	elif [ $count -eq 3 ] 
		then

		task = "Generating new hostapd.conf"
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
logger_stdout_level=2" > /etc/hostapd/hostapd.conf
	elif [ $count -eq 4 ] 
		then

		task = "Linking new hostapd.conf"
		sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd
		sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd
	
	elif [ $count -eq 5 ] 
		then

		task = "Generating new dnsmasq.conf"

		sudo echo "no-resolv
interface=wlan0
listen-address=192.168.1.254
server=8.8.8.8 # Use Google DNS
domain-needed # Don't forward short names
bogus-priv # Drop the non-routed address spaces.
dhcp-range=192.168.1.100,192.168.1.150,12h # IP range and lease time
#log each DNS query as it passes through
log-queries
dhcp-authoritative" > /etc/dnsmasq.conf

		sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
	elif [ $count -eq 6 ] 
		then
		
		task = "Generating new iptable Rules"
		sudo iptables -F
		sudo iptables -t nat -F
		sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE 
		sudo iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
		sudo iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT
	elif [ $count -eq 7 ]
		then

		task = "Allowing ip_forward"
		sudo sed -i '28 s/#//' /etc/sysctl.conf
		sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
	elif [ $count -eq 8 ]
		then

		task = "Updating startup activities"
		sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
		sudo sed -i '20i\iptables-restore < \/etc\/iptables.ipv4.nat\' /etc/rc.local
	else
		task = "Finished"
		count=$(( $count - 1 ))
	fi
    count=$(( $count + 1 ))
    runtime=$(( $cur-$start ))
    estremain=$(( ($runtime * $total / $count)-$runtime ))
    printf "\r%d.%d%% complete ($count of $total tasks) - est %d:%0.2d remaining - $task\e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))
done
