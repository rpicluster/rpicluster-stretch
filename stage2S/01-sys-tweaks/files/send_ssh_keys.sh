key=`ssh-keygen -t rsa -C pi@192.168.1.254`
cd /rpicluster/config
output=`python -c 'from functions import *; print " ".join([item[0] for item in get_nodes()])'`
for i in ${output[@]}
do
    fab send_SSH_keys:"$key" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,running
    echo -e "New SSH key created for Node at $i.\n"
done
