sudo python config.py &
output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
for i in ${output[@]}
do
    fab config_ip -u pi -H "$i"
done
#pkill config.py

