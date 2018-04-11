import os, sys
sys.path.append('/rpicluster/config')
from functions import *



if(os.path.isfile("/etc/udev/rules.d/72-static-name.rules") == False):
    stream = os.popen("ip addr", 'r')
    ip_output = stream.read()
    mac = getmac(ip_output, "wlan0")
    f = open("/etc/udev/rules.d/72-static-name.rules","w")
    f.write("ACTION==\"add\", SUBSYSTEM==\"net\", DRIVERS==\"?*\", ATTR{address}==\"%s\", KERNEL==\"w*\",NAME=\"wlan0\"" % mac)
    f.close()
    stream.close()


