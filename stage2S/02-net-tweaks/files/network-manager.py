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
        1: "/rpicluster/network-manager/disable-wifi.sh",
        2: "/rpicluster/network-manager/disable-switch.sh",
        3: "/rpicluster/network-manager/disable-otg.sh",
    }
    return switcher.get(option, "Invalid Network Option")


f = open("/rpicluster/network-manager/configured","r")
network = f.read(1)
print("Select a networking option:\n")
option = input("1 = wifi to wifi\n2 = wifi to ethernet-switch\n3 = wifi to OTG")
if(option != network):
	os.system("sudo bash " + switch_disable(network))
	os.system("sudo bash " + switch_enable(option)
	os.system("sudo echo " + option + " > /rpicluster/network-manager/configured")

else:
	print("This network configuration is already active.")

f.close()
