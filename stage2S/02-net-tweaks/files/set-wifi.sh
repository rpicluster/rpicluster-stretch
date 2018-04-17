

read -p "Would you like to connect your cluster to the internet? (y/n) " answer
echo " "

if [[ $answer == 'y' ]]; then
	
	echo "- - - Set Up Wifi Interface - - -"
	echo " "
	read -p "Make sure to plug in the wifi adaptor! Press enter to continue." none
	echo " "
	read -p "Enter network ssid: " ssid
	read -sp "Enter network psk: " psk

	echo " "

	sudo echo "network={
	    ssid=\"$ssid\"
	    psk=\"$psk\"
	}" >> /etc/wpa_supplicant/$1

fi

