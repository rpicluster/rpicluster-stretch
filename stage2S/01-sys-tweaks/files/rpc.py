import sys, os


if(sys.argv[1] == "network"):
    os.system("sudo python /rpicluster/network-manager/network-manager.py")

elif(sys.argv[1] == "update"):
    os.system("sudo bash /rpicluster/config/update.sh")

elif(sys.argv[1] == "configure"):
    os.system("sudo bash /rpicluster/config/config_ip.sh && sudo reboot -h now")

elif(sys.argv[1] == "sshkeys"):
    os.system("sudo bash /rpicluster/config/send_ssh_keys.sh")

elif(sys.argv[1] == "status"):
    os.system("sudo python /rpicluster/network-manager/status.py")

elif(sys.argv[1] == "reboot"):
    os.system("sudo bash /rpicluster/config/reboot.sh")

elif(sys.argv[1] == "shutdown"):
    os.system("sudo bash /rpicluster/config/shutdown.sh")

elif(sys.argv[1] == "install"):
    os.system("sudo bash /rpicluster/config/install.sh sys.argv[2]")

else:
    os.system("sudo python /rpicluster/config/help.py")
