import os, sys

def getmac(ip_output):
    output = ip_output.split("\n")
    # for x in range(len(output)):
    #     if ("NO-CARRIER" in output[x]) and ("wlan" in output[x]):
    #         content = output[x+1].split(" ")
    #         return content[len(content)-3]
    for x in range(len(output)):
        if("wlan0" in output[x]):
            content = output[x+1].split(" ")
            return content[len(content)-3]



if(os.path.isfile("/etc/udev/rules.d/72-static-name.rules") == False):
    stream = os.popen("ip addr", 'r')
    ip_output = stream.read()
    mac = getmac(ip_output)
    f = open("/etc/udev/rules.d/72-static-name.rules","w")
    f.write("ACTION==\"add\", SUBSYSTEM==\"net\", DRIVERS==\"?*\", ATTR{address}==\"%s\", KERNEL==\"w*\",NAME=\"wlan0\"" % mac)
    f.close()
    stream.close()


