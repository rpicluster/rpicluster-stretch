import sys

location = str(sys.argv[1])
print("- - - Set Up Wifi Interface - - -")
ssid = str(input("\nEnter network ssid: "))
psk = str(input("\nEnter network psk: "))
os.system("sudo echo network={\n    ssid=\"" + ssid + "\"\n    psk=\"" + psk + "\"\n} >> /etc/wpa_supplicant/" + location)
