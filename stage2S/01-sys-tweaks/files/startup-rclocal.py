import os




f = open("/rpicluster/network-manager/configured","r")
network = f.read(1)
configured = f.read(1)
if(int(network) > 0 and configured == "0"):
    print("Configuring Cluster Nodes . . .")
    os.system("sudo bash /rpicluster/config/config_ip.sh")


f.close()
