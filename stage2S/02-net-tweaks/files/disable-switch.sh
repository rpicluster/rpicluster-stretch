#!/bin/bash


echo "
Disabling Wifi-Ethernet_Switch networking scheme . . .
"

count=1
total=4
start=`date +%s`

while [ $count -le $total ]; do

    if [ $count -eq 1 ]
    	then

    	task="Restoring wpa_supplicant.conf"
    	sudo rm /etc/wpa_supplicant/wpa_supplicant.conf
		sudo mv /etc/wpa_supplicant/wpa_supplicant.conf.orig /etc/wpa_supplicant/wpa_supplicant.conf

	elif [ $count -eq 2 ]
		then

		task="Restoring dhcpcd.conf"
		sudo rm /etc/dhcpcd.conf
		sudo mv /etc/dhcpcd.conf.orig /etc/dhcpcd.conf
	
	elif [ $count -eq 3 ] 
		then

		task="Restoring dnsmasq.conf"
		sudo rm /etc/dnsmasq.conf
		sudo touch /etc/dnsmasq.conf

	elif [ $count -eq 4 ] 
		then

		task="Restoring rc.local"
		sudo sed -i '20d' /etc/rc.local

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

