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

w = open("/rpicluster/config/.warn")
warn = int(w.read(1))
if(int(warn)):
    sys.stdout.write("\033[1;31mWARNING: ")
    val = raw_input("\033[1;37mLeave previous networking scheme connected durring this process. disable warning (y/n) ")
    if(str(val) == "y"):
        os.system("sudo echo 0 > /rpicluster/config/.warn")

option = int(input("\nSelect a networking option: "))


f.close()

if(option != network):
    os.system("sudo bash " + switch_disable(network))
    os.system("sudo bash " + switch_enable(option))
    os.system("sudo echo " + str(option) + "0" +" > /rpicluster/network-manager/configured")
    if(option != 0):
        print("\n\nConfiguring nodes . . . ")
        os.system("sudo bash /rpicluster/config/config_ip.sh")
    raw_input("\nIf applicable, connect new networking scheme. Press enter when complete. ")
    if(option == 1):
        os.system("sudo python /rpicluster/network-manager/link_wifi_adaptor.py wlan1")
    print("\nCluster will now reboot.")
    os.system("sudo reboot -h now")
else:
    print("This network configuration is already active.")

