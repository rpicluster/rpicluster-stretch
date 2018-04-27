cd /rpicluster/config
output=`python -c 'from functions import *; print " ".join([item[0] for item in get_nodes()])'`
for i in ${output[@]}
do
    fab shutdown_nodes -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running
done
sudo shutdown -h now
