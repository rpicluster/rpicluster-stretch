#!/bin/bash


echo "
Enabling Base networking scheme . . .
"

count=1
total=5
start=`date +%s`

while [ $count -le $total ]; do

    if [ $count -eq 1 ]
    	then

    	task="Installing host services"
    	sudo apt-get install -y dnsmasq
		sudo apt-get install -y hostapd
		sudo apt-get install -y rng-tools
    
	elif [ $count -eq 2 ]
		then

		task="Updating dhcpcd.conf"
		sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

		sudo echo "interface wlan0
static ip_address=192.168.1.254/24
#static routers=192.168.1.1
static domain_name_servers=8.8.8.8" >> /etc/dhcpcd.conf


	
	elif [ $count -eq 3 ] 
		then

		task="Generating new hostapd.conf"
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

		task="Linking new hostapd.conf"
		sudo sed -i '10s/.*/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

		sudo sed -i '19s/.*/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd


	elif [ $count -eq 5 ] 
		then

		task="Generating new dnsmasq.conf"
		sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

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


	else
		task="Finished"

	fi
	cur=`date +%s`
	
    runtime=$(( $cur-$start ))
    estremain=$(( ($runtime * $total / $count)-$runtime ))
    printf "\r%d.%d%% complete ($count of $total tasks) - est %d:%0.2d remaining - $task\e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))
    if [ $count -lt 7 ]
		then
        count=$(( $count + 1 ))
    fi
done
printf "\r%d.%d%% complete (5 of 5 tasks) - est %d:%0.2d remaining - Finished\e[K" $(( 5*100/$total )) $(( (5*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))

