import os

def get_nodes():
    f = open("/rpicluster/config/nodes","r")
    line = f.readline()
    machines = []
    while(line!=''):
        split = line.split(',')
        machines.append((split[0].rstrip(), split[2].rstrip()))
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
    command = "ping -c 1 " + hostname + " > /dev/null"
    return os.system(command)

#read the stamp and give back the network name and password
def read_stamp(magic_num, file):
    pos = 0
    fd = open(file, 'rb')
    char = ord(fd.read(1))
    first = "" # first is the first half of the image, including the magic number
    while(char != None):
        first += chr(char)
        if(char == ord(magic_num[pos]) and pos == len(magic_num)-1):
            break
        elif(char == ord(magic_num[pos])):
            pos = pos + 1
        else:
            pos = 0
        char = ord(fd.read(1))
    len_network = fd.read(8)
    len_network = int(len_network.decode('utf-8'), 2)
    len_pass = fd.read(8)
    len_pass = int(len_pass.decode('utf-8'), 2)
    name = fd.read(len_network)
    passw = fd.read(len_pass)
    return [bin_to_string(name), bin_to_string(passw)]

def bin_to_string(binary_string):
    return ''.join(format(chr(int(binary_string[i:i+8], 2))) for i in range(0, len(binary_string), 8))
