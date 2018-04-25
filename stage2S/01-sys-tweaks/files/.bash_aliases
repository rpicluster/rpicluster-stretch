alias rpc-networkmanager="sudo python /rpicluster/network-manager/network-manager.py"
alias rpc-update="(sudo bash /rpicluster/config/update.sh &) && sudo apt-get update && sudo apt-get upgrade -y"
alias rpc-configure="sudo bash /rpicluster/config/config_ip.sh && sudo reboot -h now"
alias rpc-help="sudo python /rpicluster/config/help.py"
alias rpc-sshkeys="sudo bash /rpicluster/config/send_ssh_keys.sh"
alias rpc-status="sudo python /rpicluster/network-manager/status.py"
alias rpc-reboot="sudo bash /rpicluster/config/reboot.sh && sudo reboot -h now"
alias rpc-shutdown="sudo bash /rpicluster/config/shutdown.sh && sudo shutdown -h now"

