package=$1

cd /rpicluster/config
output=`python -c 'from functions import *; print " ".join([item[0] for item in get_nodes()])'`
for i in ${output[@]}
do
    fab install:"$package" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running
done
sudo apt-get install "$package" -y
