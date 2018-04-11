sudo python /rpicluster/config/config.py &
cd /rpicluster/config
output=`python -c 'from functions import *; print " ".join(get_machines())'`
counter=0
sudo mv /etc/dnsmasq.conf.orig /etc/dnsmasq.conf
for i in ${output[@]}
do
    echo "Attempting to configure machine at IP: $i"
    rv=$(fab pingall -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running)
    if [ $rv -eq 0 ];
    then
        counter=$((counter+1))
        fab config_ip:"$counter" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,running
        echo -e "Node configured\n"
    else
    	echo -e "Failed to configure Non-Node device.\n"
    fi

done
echo "All Nodes Configured. Rebooting Cluster."
sed -i 's/./1/2' /rpicluster/network-manager/configured
sudo reboot -h now

