import os


f = open("/etc/network-manager/configured","r")
network = f.read(1)
if(network == 0):
	os.system("python /etc/network-manager/network-manager.py")


f.close()
