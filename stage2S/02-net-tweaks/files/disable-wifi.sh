#!/bin/bash


echo "
Disabling Wifi-Wifi networking scheme . . .
"

count=1
total=6
start=`date +%s`

while [ $count -le $total ]; do

    if [ $count -eq 1 ]
    	then

    	task="Removing wpa_supplicant"
    	sudo rm /etc/wpa_supplicant/wpa_supplicant-wlan1.conf


	elif [ $count -eq 2 ]
		then

		task="Restoring dhcpcd.conf"
		sudo rm /etc/dhcpcd.conf
		sudo mv /etc/dhcpcd.conf.orig /etc/dhcpcd.conf

		
	elif [ $count -eq 3 ] 
		then

		task="Removing hostapd.conf"
		sudo rm /etc/hostapd/hostapd.conf


	elif [ $count -eq 4 ] 
		then

		task="Unlinking hostapd.conf"
		sudo sed -i '10s/.*/#DAEMON_CONF=""/' /etc/default/hostapd
		sudo sed -i '19s/.*/#DAEMON_CONF=/' /etc/init.d/hostapd

		
	elif [ $count -eq 5 ] 
		then

		task="Restoring dnsmasq.conf"
		sudo rm /etc/dnsmasq.conf
		sudo touch /etc/dnsmasq.conf
		
	elif [ $count -eq 6 ] 
		then

		task="Restoring rc.local"
		sed -i '20d' /etc/rc.local

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

