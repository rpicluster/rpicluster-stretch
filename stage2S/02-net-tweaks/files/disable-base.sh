#!/bin/bash


echo "
Disabling Base networking scheme . . .
"

count=1
total=4
start=`date +%s`

while [ $count -le $total ]; do

    if [ $count -eq 1 ]
    	then

    	task="Restoring dhcpcd.conf"
    	sudo rm /etc/dhcpcd.conf
		sudo mv /etc/dhcpcd.conf.orig /etc/dhcpcd.conf


	elif [ $count -eq 2 ]
		then

		task="Removing hostapd.conf"
		sudo rm /etc/hostapd/hostapd.conf

	elif [ $count -eq 3 ]
		then


		task="Unlinking hostapd.conf"
		sudo sed -i '10s/.*/#DAEMON_CONF=""/' /etc/default/hostapd
		sudo sed -i '19s/.*/#DAEMON_CONF=/' /etc/init.d/hostapd

	elif [ $count -eq 4 ]
		then

		task="Restoring dnsmasq.conf"
		sudo rm /etc/dnsmasq.conf
		sudo mv /etc/dnsmasq.conf.orig /etc/dnsmasq.conf



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

