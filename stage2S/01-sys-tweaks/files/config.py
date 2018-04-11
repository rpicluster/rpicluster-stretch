import os

class IpSender(object):
    
    ip = 0
    def sendIP(self, mac):
        self.ip+=1
        desiredIp = "192.168.1." + str(self.ip)
        with open("/etc/dnsmasq.conf", "a") as configFile:
            configFile.write("dhcp-host=" + mac + "," + desiredIp + "\n")
        with open("/rpicluster/config/nodes", "wb") as nodeFile:
            nodeFile.write(desiredIp + "," + mac + "," + "node" + str(self.ip) + "\n")
        print("Configured IP: " + desiredIp + " on node" + str(self.ip) + " - " + mac)
        return str(desiredIp)


import zerorpc

s = zerorpc.Server(IpSender())
s.bind("tcp://192.168.1.254:4444")
s.run()
