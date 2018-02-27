sudo python server_demo.py &
P1=$!
output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
for i in ${output[@]}
do
    fab run_demo -u pi -H "$i"
done
wait $P1


