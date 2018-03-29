echo "- - - Set Up Wifi Interface - - -"
echo " "
read -p "Enter network ssid: " ssid
read -sp "Enter network psk: " psk

echo

sudo echo "network={
    ssid=\"$ssid\"
    psk=\"$psk\"
}" >> /etc/wpa_supplicant/$1
