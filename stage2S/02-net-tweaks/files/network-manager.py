import os, sys

def switch_disable(network):
    switcher = {
        1: "/rpicluster/network-manager/disable-wifi.sh",
        2: "/rpicluster/network-manager/disable-switch.sh",
        3: "/rpicluster/network-manager/disable-otg.sh",
        
    }
    return switcher.get(network)

def switch_enable(option):
    switcher = {
        1: "/rpicluster/network-manager/enable-wifi.sh",
        2: "/rpicluster/network-manager/enable-switch.sh",
        3: "/rpicluster/network-manager/enable-otg.sh",
    }
    return switcher.get(option, "Invalid Network Option")

f = open("/rpicluster/network-manager/configured","r")
network = f.read(1)
print("Select a networking option:\n")
option = int(input("1 = wifi to wifi\n2 = wifi to ethernet-switch\n3 = wifi to OTG\n"))
if(option != network):
    print("Network: " + network)
    print("Option: " + str(option))
    if(network != "0"):
	    os.system("sudo bash " + switch_disable(int(network)))
	os.system("sudo bash " + switch_enable(option))
    os.system("sudo sh -c \"echo " + str(option) + " > /rpicluster/network-manager/configured\"")
	# os.system("sudo echo " + str(option) + " > /rpicluster/network-manager/configured")

else:
	print("This network configuration is already active.")

f.close()
