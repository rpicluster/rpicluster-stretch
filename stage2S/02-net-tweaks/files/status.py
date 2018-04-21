import os, sys
sys.path.append('/rpicluster/config')
from functions import *


f = open("/rpicluster/network-manager/configured","r")

machines = get_nodes()
network = int(f.read(1))
stream = os.popen("ip addr", 'r')
ip_output = stream.read()
internet_ip = ""
access_point = ""
internet_name = ""
connection_name = ""



if(network != 0):

    if(network == 1):
        internet_ip = str(get_ip(ip_output, "wlan1"))
        internet_name = "wlan1"
        access_point = str(get_ip(ip_output, "wlan0"))
        connection_name = "Access Point"

    elif(network == 2):
        internet_ip = str(get_ip(ip_output, "wlan0"))
        internet_name = "wlan0"
        access_point = str(get_ip(ip_output, "eth0"))
        connection_name = "Switch"

    # else if(network == 3):
    print("\nCurrent network configuration: " + network_type(network))

    if(internet_ip != "None"):
        print("                            |")
        print("                            |")
        print("                            --> "+ connection_name + "--> " + access_point)
        for x in range(len(machines)):
            print("                                                       |")
            print("                                                       --> " + machines[x][0] + " - " + machines[x][1])
    else:
        print("                       |")
        print("                       |")
        print("                       --> "+ connection_name + "--> " + access_point)
        for x in range(len(machines)):
            print("                                                  |")
            print("                                                  --> " + machines[x][0] + " - " + machines[x][1])

else:
    print("\nNo rpicluster Network configured ! ! !\n")
