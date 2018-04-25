import os

class IpSender(object):

    ip = 0
    slots = 1
    def sendIP(self, mac):
        self.ip+=1
        desiredIp = "192.168.1." + str(self.ip)
        with open("/etc/dnsmasq.conf", "a") as configFile:
            configFile.write("dhcp-host=" + mac + "," + desiredIp + "\n")
        with open("/rpicluster/config/nodes", "a") as nodeFile:
            nodeFile.write(desiredIp + "," + mac + "," + "node" + str(self.ip) + "\n")
        with open("~/nfs/mpi/mpiHosts", "a") as mpiHosts:
            mpiHosts.write("node" + str(self.ip) + " slots=" + str(self.slots) + " max-slots=" + str(self.slots) + "\n")
        with open("/etc/hosts", "a") as hosts:
            hosts.write(desiredIp + "    node" + str(self.ip))
        print("Configured IP: " + desiredIp + " on node" + str(self.ip) + " - " + mac)
        return str(desiredIp)


import zerorpc

s = zerorpc.Server(IpSender())
s.bind("tcp://192.168.1.254:4444")
s.run()
