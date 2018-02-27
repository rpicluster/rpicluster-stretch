output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
for i in ${output[@]}
do
    fab calibrate_screen -U pi -H "$i"
done
