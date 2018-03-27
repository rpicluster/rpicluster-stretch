import sys

location = str(sys.argv[1])
print("- - - Set Up Wifi Interface - - -\n")
ssid = input("Enter network ssid: ")
print("\n")
psk = input("Enter network psk: ")
command = str("sudo echo network={\n    ssid=\"" + ssid + "\"\n    psk=\"" + psk + "\"\n} >> /etc/wpa_supplicant/" + location)
os.system(command)
