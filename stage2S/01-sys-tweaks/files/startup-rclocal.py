import os




f = open("/rpicluster/network-manager/configured","r")
network = f.read(1)
configured = f.read(1)
if(int(network) > 0 and configured == "0"):
    print("Configuring Cluster Nodes . . .")
    # sudo sed -i '20i\sudo systemctl start hostapd\' /etc/rc.local
    # sudo sed -i '21i\sudo systemctl start dnsmasq\' /etc/rc.local
    # sudo sed -i '22i\sudo systemctl start dhcpcd\' /etc/rc.local
    # sudo sed -i '23i\sudo systemctl daemon-reload\' /etc/rc.local
    os.system("sudo bash /rpicluster/config/config_ip.sh")


f.close()
