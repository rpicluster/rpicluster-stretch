#!/bin/bash

echo "

Enabling Base networking scheme . . .
"

count=1
total=4
start=`date +%s`

while [ $count -le $total ]; do

	if [ $count -eq 1 ]
		then

		task="Updating dhcpcd.conf"
		sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

		sudo echo "interface wlan0
static ip_address=192.168.1.254/24" >> /etc/dhcpcd.conf


	elif [ $count -eq 2 ]
		then

		task="Generating new hostapd.conf"

		output=`python -c 'from functions import *; print " ".join(read_stamp("0100010001000001010101110100000101000101", "/boot/stamp"))'`
		counter=0
		network_name=""
		password=""
		for i in ${output[@]}
		do
			if [ counter -eq 0 ]
			then 
				network_name=$i
			else
				password=$i
			fi
			counter=$((counter+1))
		done
		
		sudo echo "#INTERFACE
interface=wlan0

#DRIVER SETTINGS
driver=nl80211

#WLAN SETTINGS
country_code=US
ssid=$network_name
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
wpa_passphrase=$password
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

	elif [ $count -eq 3 ]
		then

		task="Linking new hostapd.conf"
		sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

		sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd


	elif [ $count -eq 4 ]
		then

		task="Generating new dnsmasq.conf"
		sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

		sudo echo "no-resolv
interface=wlan0
listen-address=192.168.1.254
server=8.8.8.8
server=8.8.4.4
cache-size=10000
domain-needed #blocks incomplete requests from leaving your network, such as google instead of google.com
bogus-priv #prevents non-routable private addresses from being forwarded out of your network
dhcp-range=192.168.1.100,192.168.1.150,12h # IP range and lease time
dhcp-authoritative #only use dnsmasq and dhcp server

#LOGGING
log-queries #log each DNS query as it passes through
log-dhcp" > /etc/dnsmasq.conf


	else
		task="Finished"

	fi
	cur=`date +%s`
    runtime=$(( $cur-$start ))
    estremain=$(( ($runtime * $total / $count)-$runtime ))
    printf "\r%d.%d%% complete ($count of $total tasks) - est %d:%0.2d remaining - $task\e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))
    if [ $count -lt 6 ]
		then
        count=$(( $count + 1 ))
    fi
done
printf "\r%d.%d%% complete (4 of 4 tasks) - est %d:%0.2d remaining - Finished\e[K" $(( 4*100/$total )) $(( (4*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))

