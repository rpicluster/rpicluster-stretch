import os, sys

def switch_disable(network):
    switcher = {
        0: "/rpicluster/network-manager/disable-base.sh",
        1: "/rpicluster/network-manager/disable-wifi.sh",
        2: "/rpicluster/network-manager/disable-switch.sh",
        3: "/rpicluster/network-manager/disable-otg.sh",
        
    }
    return switcher.get(network)

def switch_enable(option):
    switcher = {
        0: "/rpicluster/network-manager/enable-base.sh",
        1: "/rpicluster/network-manager/enable-wifi.sh",
        2: "/rpicluster/network-manager/enable-switch.sh",
        3: "/rpicluster/network-manager/enable-otg.sh",
    }
    return switcher.get(option, "Invalid Network Option")

f = open("/rpicluster/network-manager/configured","r")
network = int(f.read(1))
print("0 = remove networking\n1 = wifi to wifi\n2 = wifi to ethernet-switch\n3 = wifi to OTG\n")

if(network != 0):
    print("Current network mode: " + str(network))

option = int(input("Select a networking option: "))
if(network == 2 and option == 1):
    raw_input("Make sure to unplug the ethernet! Press enter to continue.")


f.close()

if(option != network):
    if(network != 0):
        os.system("sudo bash " + switch_disable(network))
    if(option != 0):
        os.system("sudo bash " + switch_enable(option))
        os.system("sudo echo " + str(option) + " > /rpicluster/network-manager/configured")
    print("Rebooting machine . . . ")
    if(option != 1 && network == 0):
        os.system("sudo bash " + switch_disable(option))
    os.system("sudo reboot -h now")
else:
    print("This network configuration is already active.")

