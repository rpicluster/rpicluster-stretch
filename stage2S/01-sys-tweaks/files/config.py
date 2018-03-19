class IpSender(object):
    
    ip = 0
    def sendIP(self, mac):
        print(mac)
        self.ip+=1
        desiredIp = "192.168.1." + str(self.ip)
        with open("/etc/dnsmasq.conf", "a") as configFile:
            configFile.write("dhcp-host=" + mac + "," + desiredIp + "\n")
        return str(desiredIp)


import zerorpc

s = zerorpc.Server(IpSender())
s.bind("tcp://192.168.1.254:4444")
# print("Running...")
s.run()
