key=`ssh-keygen -t rsa -C pi@192.168.1.254`
cd /rpicluster/config
output=`python -c 'from functions import *; print " ".join(get_machines())'`
for i in ${output[@]}
do
    fab send_SSH_keys "$key" -u pi -H "$i" -p "raspberry"
done
