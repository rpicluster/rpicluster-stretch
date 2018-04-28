import os

def get_nodes():
    f = open("/rpicluster/config/nodes","r")
    line = f.readline()
    machines = []
    while(line!=''):
        split = line.split(',')
        machines.append((split[0], split[2]))
        line = f.readline()
    return machines


def get_ip(ip_output, interface):
    output = ip_output.split("\n")
    for x in range(len(output)):
        if (interface in output[x]):
            content = output[x+2].split(" ")
            if(len(content) > 1):
                return content[5]
            return None

def network_type(network):
    switcher = {
        1: "Wifi-Wifi",
        2: "Wifi-Switch",
        3: "Wifi-OTG",

    }
    return switcher.get(network)

#get all licensed IPs
def get_machines():
        machines = []
        leases = open("/var/lib/misc/dnsmasq.leases", "r")
        leases = leases.readlines()
        for lease in leases:
                ip = lease.split(" ")[2]
                machines.append(ip)
        return machines

#takes output of "ip addr" and desired interface, returns interface mac
def getmac(ip_output, interface):
    output = ip_output.split("\n")
    for x in range(len(output)):
        if(interface in output[x]):
            content = output[x+1].split(" ")
            return content[len(content)-3]

def ping_node(hostname):
    response = os.system("ping " + hostname)
    if response == 0:
        return 0
    else:
        return 1

        