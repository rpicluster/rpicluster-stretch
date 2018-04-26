sudo python /rpicluster/config/config.py &
cd /rpicluster/config
output=`python -c 'from functions import *; print " ".join(get_machines())'`
counter=0
sudo cp /etc/dnsmasq.conf.orig /etc/dnsmasq.conf
sudo cp /etc/hosts.orig /etc/hosts
sudo rm nodes
sudo touch nodes
sudo chmod 777 nodes
sudo echo "#MPI CLUSTER SETUP" >> /etc/hosts
sudo echo "192.168.1.254    rpicluster" >> /etc/hosts
sudo echo "rpicluster slots=1  max-slots=1" > /home/pi/nfs/mpi/mpiHosts
for i in ${output[@]}
do
    echo "Attempting to configure machine at IP: $i"
    rv=$(fab pingall -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running,stderr)

    if [[ ! -z "$rv" && "$rv" != ’’ && $rv -eq 0]]
    then
        counter=$((counter+1))
        fab config_ip:"$counter" -u pi -H "$i" -p "raspberry" --abort-on-prompts --hide warnings,stdout,aborts,status,running,stderr
        echo -e "Node configured.\n"
    else
        echo -e "Skip configuration of non-node device.\n"
    fi

done
echo "$counter nodes configured."
sed -i 's/./1/2' /rpicluster/network-manager/configured

