#get all licensed IPs
def getMachines():
        machines = []
        leases = open("/var/lib/misc/dnsmasq.leases", "r")
        leases = leases.readlines()
        for lease in leases:
                ip = lease.split(" ")[2]
                machines.append(ip)
        return machines
