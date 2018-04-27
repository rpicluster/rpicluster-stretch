#!/bin/bash


echo "

Enabling Wifi-Wifi networking scheme . . .
"

count=1
total=8
start=`date +%s`

while [ $count -le $total ]; do

    if [ $count -eq 1 ]
    	then

    	task="Configuring Wifi Adaptor"
    	sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf
		sudo bash /rpicluster/network-manager/set-wifi.sh wpa_supplicant-wlan1.conf
		# sudo python /rpicluster/network-manager/link_wifi_adaptor.py wlan1
		echo " "

	elif [ $count -eq 2 ]
		then


		task="Updating dhcpcd.conf"
		sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

		sudo echo "interface wlan0
	metric 150
	static ip_address=192.168.1.254/24
	#static routers=192.168.1.1
	#static domain_name_servers=8.8.8.8 

interface wlan1
	metric 100" >> /etc/dhcpcd.conf
	elif [ $count -eq 3 ]
		then

		task="Generating new hostapd.conf"
		sudo echo "#INTERFACE
interface=wlan0

#DRIVER SETTINGS
driver=nl80211

#WLAN SETTINGS
country_code=US
ssid=rpicluster-AP
channel=11
wmm_enabled=1
hw_mode=g

#N-WLAN SETTINGS
ieee80211n=1
obss_interval=0
require_ht=0
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]

#WPA SETTINGS
wpa=2
wpa_passphrase=rpicluster
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
auth_algs=3
macaddr_acl=0

# Logging
logger_syslog=-1
logger_syslog_level=3
logger_stdout=-1
logger_stdout_level=2" > /etc/hostapd/hostapd.conf

	elif [ $count -eq 4 ]
		then

		task="Linking new hostapd.conf"
		sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd
		sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd

	elif [ $count -eq 5 ]
		then

		task="Generating new dnsmasq.conf"

		sudo echo "no-resolv
interface=wlan0
listen-address=192.168.1.254
bind-interfaces #ensures that Dnsmasq will listen only to the addresses specificied with listen-address
cache-size=10000 #local copy of the addresses we have visited
domain-needed #blocks incomplete requests from leaving your network, such as google instead of google.com
bogus-priv #prevents non-routable private addresses from being forwarded out of your network
dhcp-range=192.168.1.100,192.168.1.150,12h # IP range and lease time
dhcp-authoritative #only use dnsmasq and dhcp server

#LOGGING
log-queries #log each DNS query as it passes through
log-dhcp" > /etc/dnsmasq.conf

		sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
	elif [ $count -eq 6 ]
		then

		task="Generating new iptable Rules"
		sudo iptables -F
		sudo iptables -t nat -F
		sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
		sudo iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
		sudo iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT
	elif [ $count -eq 7 ]
		then

		task="Allowing ip_forward"
		sudo sed -i '28 s/#//' /etc/sysctl.conf
		sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
	elif [ $count -eq 8 ]
		then

		task="Updating startup activities"
		sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
		sudo sed -i '20i\iptables-restore < \/etc\/iptables.ipv4.nat\' /etc/rc.local
	else
		task="Finished"

	fi
	cur=`date +%s`

    runtime=$(( $cur-$start ))
    estremain=$(( ($runtime * $total / $count)-$runtime ))
    printf "\r%d.%d%% complete ($count of $total tasks) - est %d:%0.2d remaining - $task\e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))
    if [ $count -lt 10 ]
		then
        count=$(( $count + 1 ))
    fi
done
printf "\r%d.%d%% complete (8 of 8 tasks) - est %d:%0.2d remaining - Finished\e[K" $(( 8*100/$total )) $(( (8*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))
