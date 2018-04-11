sudo python /rpicluster/config/config.py &
cd /rpicluster/config
output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
counter=0
for i in ${output[@]}
do
    rv=$(fab pingall -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running)
    echo rv \= $rv
    if [ $rv -eq 0 ];
    then
        counter=$((counter+1))
    fi
    echo $counter
    fab config_ip:"$counter" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running
done
sudo reboot -h now
