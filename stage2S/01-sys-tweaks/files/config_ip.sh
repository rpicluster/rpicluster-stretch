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
        echo "Node configured"
    fi
done
sudo reboot -h now

