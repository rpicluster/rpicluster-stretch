sudo python /rpicluster/config/config.py &
cd /rpicluster/config
output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
counter=0
for i in ${output[@]}
do
    counter=$((counter+1))
    fab config_ip:"$counter" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings
done
sudo reboot -h now
