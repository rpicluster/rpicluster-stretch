import os




f = open("/rpicluster/network-manager/configured","r")
network = f.read(1)
if(network == "0"):
    print("\n- - - Congratulations on starting up your rpicluster ! - - -\n")
    os.system("python /rpicluster/network-manager/network-manager.py")
configured = f.read(1)
if(int(network) > 0 and configured == "0"):
	print("\nWARNING: Looks like your nodes are not configured !")
	print("Run rpicluster-configure to configure the cluster !\n")


f.close()
