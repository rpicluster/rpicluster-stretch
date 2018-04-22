sudo python /rpicluster/config/config.py &
cd /rpicluster/config
output=`python -c 'from functions import *; print " ".join(get_machines())'`
counter=0
sudo cp /etc/dnsmasq.conf.orig /etc/dnsmasq.conf
sudo rm nodes
sudo touch nodes
sudo chmod 777 nodes
$zero=0
$zero_string="0"
for i in ${output[@]}
do
    echo "Attempting to configure machine at IP: $i"
    rv=$(fab pingall -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running)

    if [ $rv -eq $zero ] || [ $rv == $zero_string ];
    then
        counter=$((counter+1))
        fab config_ip:"$counter" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running
        echo -e "Node configured.\n"
    else
        echo -e "Skip configuration of non-node device.\n"
    fi

done
echo "All nodes configured. Rebooting cluster."
sed -i 's/./1/2' /rpicluster/network-manager/configured
sudo reboot -h now

