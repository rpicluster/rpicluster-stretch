import os, sys
sys.path.append('/rpicluster/config')
from functions import *

interface = sys.argv[1]
path = "/etc/udev/rules.d/72-static-{}.rules".format(interface)

if(os.path.isfile(path) == False):

    stream = os.popen("ip addr", 'r')
    ip_output = stream.read()
    mac = getmac(ip_output, interface)
    f = open(path,"w")
    f.write("ACTION==\"add\", SUBSYSTEM==\"net\", DRIVERS==\"?*\", ATTR{address}==\"{}\", KERNEL==\"w*\",NAME=\"{}\"".format(mac, interface))
    f.close()
    stream.close()


