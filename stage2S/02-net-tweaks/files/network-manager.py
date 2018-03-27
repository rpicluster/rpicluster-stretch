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
network = int(f.read(1))
print("Select a networking option:\n")
print("1 = wifi to wifi\n2 = wifi to ethernet-switch\n3 = wifi to OTG\n")
option = int(input("Select a networking option: "))
f.close()
if(option != network):
    print("Network: " + str(network))
    print("Option: " + str(option))
    if(network != 0):
	    os.system("sudo bash " + switch_disable(network))
	os.system("sudo bash " + switch_enable(option))
    os.system("sudo echo " + str(option) + " > /rpicluster/network-manager/configured")
    print("Rebooting machine . . . ")
    os.system("sudo reboot -h now")

else:
	print("This network configuration is already active.")

