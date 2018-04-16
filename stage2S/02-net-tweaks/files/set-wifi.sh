

read -p "Would you like to connect your cluster to the internet? (y/n) " answer

if [[ $answer == 'y' ]]; then
	
	echo "- - - Set Up Wifi Interface - - -"
	echo " "
	read -p "Enter network ssid: " ssid
	read -sp "Enter network psk: " psk

	echo

	sudo echo "network={
	    ssid=\"$ssid\"
	    psk=\"$psk\"
	}" >> /etc/wpa_supplicant/$1

fi

