import os
import subprocess
import zerorpc
from uuid import getnode as get_mac



#Returns MAC Address in xx:xx:xx:xx:xx:xx format
def getMacAddr():
        mac = get_mac()
        print("mac Decimal: {0}".format(mac))
        mac = hex(mac).split('x')[-1]
        new_mac = ""
        for x in range(12):
                if(x%2 == 0 and x != 0):
                        new_mac += ":"

                new_mac += mac[x]

        print("mac hex: {0}".format(new_mac))
        return new_mac

c = zerorpc.Client()
c.connect("tcp://192.168.0.254:4444")
mac = getMacAddr()
print(c.sendIP(mac))
