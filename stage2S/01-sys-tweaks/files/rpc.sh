if [[ ! -z "$1" || "$1" != ’’]]]
    then
    sudo python /rpicluster/config/help.py

elif [ $1 -eq "network" ]
    then
    sudo python /rpicluster/network-manager/network-manager.py

elif [ $1 -eq "update" ]
    then
    sudo bash /rpicluster/config/update.sh

elif [ $1 -eq "configure" ]
    then
    sudo bash /rpicluster/config/config_ip.sh && sudo reboot -h now

elif [ $1 -eq "sshkeys" ]
    then
    sudo bash /rpicluster/config/send_ssh_keys.sh

elif [ $1 -eq "status" ]
    then
    sudo python /rpicluster/network-manager/status.py

elif [ $1 -eq "reboot" ]
    then
    sudo bash /rpicluster/config/reboot.sh

elif [ $1 -eq "shutdown" ]
    then
    sudo bash /rpicluster/config/shutdown.sh

elif [ $1 -eq "install" ]
    then
    sudo bash /rpicluster/config/install.sh $2

else
    sudo python /rpicluster/config/help.py

fi