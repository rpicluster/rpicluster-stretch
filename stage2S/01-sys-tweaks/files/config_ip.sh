sudo python config.py &
P1=$!
output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
for i in ${output[@]}
do
    if [ "$1" = "-t" ]
	then
    	fab config_ip_touch -u pi -H "$i"
	else
    	fab config_ip -u pi -H "$i"
	fi
done
wait $P1

