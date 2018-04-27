import os




f = open("/rpicluster/network-manager/configured","r")
network = f.read(1)
if(network == "0"):
    print("- - - Congratulations on starting up your rpicluster - - -\n")
    os.system("python /rpicluster/network-manager/network-manager.py")

f.close()
