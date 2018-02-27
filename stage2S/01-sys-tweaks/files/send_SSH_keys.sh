output=`python -c 'from list_leases import *; print " ".join(getMachines())'`
for i in ${output[@]}
do
    key=`ssh-keygen -t rsa -C pi@192.168.0.254`
    fab send_SSH_keys "$key" -u pi -H "$i"
done
