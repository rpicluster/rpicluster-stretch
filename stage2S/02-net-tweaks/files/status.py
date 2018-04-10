import os

def get_nodes():
    f = open("/rpicluster/config/nodes","r")
    line = f.readline()
    machines = []
    while(line!=None):
        split = line.split(',')
        machines.append(split[0])
        line = f.readline()
    return machines


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

    print("\nCurrent network configuration: " + network_type(network))
    print("\nInternet on " + internet_name + "--> " + internet_ip)
    print("                            |")
    print("                            |")
    print("                            --> "+ connection_name + "--> " + access_point)
    for x in range(len(machines)):
        print("                                                       |")
        print("                                                       --> " + machines[x])

else:
    print("\nNo rpicluster Network configured ! ! !\n")
