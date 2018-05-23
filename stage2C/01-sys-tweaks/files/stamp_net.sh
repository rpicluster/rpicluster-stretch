cd /rpicluster/config

output=`python -c 'from functions import *; print " ".join(read_stamp("0100010001000001010101110100000101000101", "/boot/stamp"))'`
counter=0
network_name=""
password=""
for i in ${output[@]}
do
    if [ $counter -eq 0 ]
    then 
        network_name=$i
    else
        password=$i
    fi
    counter=$((counter+1))
done

sudo sed -i '6s/.*/    ssid="$network_name"/' /etc/wpa_supplicant/wpa_supplicant.conf
sudo sed -i '7s/.*/    psk="$password"/' /etc/wpa_supplicant/wpa_supplicant.conf
