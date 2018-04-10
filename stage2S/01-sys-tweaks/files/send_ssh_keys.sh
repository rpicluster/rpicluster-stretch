key=`ssh-keygen -t rsa -C pi@192.168.1.254`
output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
for i in ${output[@]}
do
    fab send_SSH_keys "$key" -u pi -H "$i" -p "raspberry"
done
