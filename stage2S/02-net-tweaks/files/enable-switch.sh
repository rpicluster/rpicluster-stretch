#!/bin/bash


echo "

Enabling Wifi-Ethernet_Switch networking scheme . . .
"


count=1
total=6
start=`date +%s`

while [ $count -le $total ]; do

    if [ $count -eq 1 ]
    	then

    	task="Generating new wpa_supplicant"
		sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig
		sudo bash /rpicluster/network-manager/set-wifi.sh wpa_supplicant.conf

	elif [ $count -eq 2 ]
		then

		task="Updating dhcpcd.conf"
		sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig
		sudo echo "interface eth0
static ip_address=192.168.1.254/24" >> /etc/dhcpcd.conf


	elif [ $count -eq 3 ]
		then

		task="Generating new dnsmasq.conf"
		sudo echo "no-resolv
interface=eth0
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

		sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

	elif [ $count -eq 4 ]
		then

		task="Generating new iptable Rules"
		sudo iptables -F
		sudo iptables -t nat -F
		sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE 
		sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
		sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

	elif [ $count -eq 5 ]
		then

		task="Allowing ip_forward"
		sudo sed -i '28 s/#//' /etc/sysctl.conf
		sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

	elif [ $count -eq 6 ]
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
    if [ $count -lt 8 ]
		then
        count=$(( $count + 1 ))
    fi
done
printf "\r%d.%d%% complete (6 of 6 tasks) - est %d:%0.2d remaining - Finished\e[K" $(( 6*100/$total )) $(( (6*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))

