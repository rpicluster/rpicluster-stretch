import os


f = open("/rpicluster/network-manager/configured","r")
network = f.read(1)
if(network == 0):
	os.system("python /rpicluster/network-manager/network-manager.py")


f.close()
