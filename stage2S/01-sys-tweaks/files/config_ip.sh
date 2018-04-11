sudo python /rpicluster/config/config.py &
cd /rpicluster/config
output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
counter=0
for i in ${output[@]}
do
    rv=$(fab pingall -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running)
    if [ $rv -eq 0 ];
    then
        counter=$((counter+1))
    fi
    fab config_ip:"$counter" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,running
done
sudo reboot -h now
