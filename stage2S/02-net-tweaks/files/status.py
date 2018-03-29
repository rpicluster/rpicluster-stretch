import os
import /rpicluster/config/list_leases


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
internet = ""
access_point = ""
connection_name ="-1"



if(connection_name != "-1"):

    if(network == 1):
        internet = get_ip(ip_output, "wlan1")
        access_point = get_ip(ip_output, "wlan0")
        connection_name = "Access Point"

    else if(network == 2):
        internet = get_ip(ip_output, "wlan0")
        access_point = get_ip(ip_output, "eth0")
        connection_name = "Switch"

    # else if(network == 3):

    print("Current network configuration: " + network_type(network))
    print("Internet--> " + internet + "\n")
    print("                  |\n")
    print("                  |\n")
    print("                  --> "+ connection_name + "--> " + access_point + "\n")
    for x in range(len(machines)):
        print("                                                          |\n")
        print("                                                          --> " + machines[x] + "\n")

else:
    print("No rpicluster Network configured ! ! !\n")
