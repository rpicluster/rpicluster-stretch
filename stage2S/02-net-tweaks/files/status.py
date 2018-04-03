import os
import sys  
sys.path.append('/rpicluster/config/')   
from list_leases import *


def get_ip(ip_output, interface):
    output = ip_output.split("\n")
    for x in range(len(output)):
        if (interface in output[x]):
            content = output[x+2].split(" ")
            return content[5]

def network_type(network):
    switcher = {
        1: "Wifi-Wifi",
        2: "Wifi-Switch",
        3: "Wifi-OTG",
        
    }
    return switcher.get(network)




f = open("/rpicluster/network-manager/configured","r")

machines = getMachines()
network = int(f.read(1))
stream = os.popen("ip addr", 'r')
ip_output = stream.read()
internet_ip = ""
access_point = ""
internet_name = ""
connection_name ="-1"



if(network != "-1"):

    if(network == 1):
        internet_ip = get_ip(ip_output, "wlan1")
        internet_name = "wlan1"
        access_point = get_ip(ip_output, "wlan0")
        connection_name = "Access Point"

    elif(network == 2):
        internet_ip = get_ip(ip_output, "wlan0")
        internet_name = "wlan0"
        access_point = get_ip(ip_output, "eth0")
        connection_name = "Switch"

    # else if(network == 3):

    print("Current network configuration: " + network_type(network))
    print("Internet on " + internet_name + "--> " + internet_ip)
    print("                           |")
    print("                           |")
    print("                           --> "+ connection_name + "--> " + access_point)
    for x in range(len(machines)):
        print("                                                              |")
        print("                                                              --> " + machines[x])

else:
    print("No rpicluster Network configured ! ! !\n")
