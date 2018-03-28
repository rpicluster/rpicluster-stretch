import os, sys

location = str(sys.argv[1])
print("- - - Set Up Wifi Interface - - -\n")
ssid = raw_input("Enter network ssid: ")
psk = raw_input("Enter network psk: ")
# command = "\'sudo echo \"network={\n    ssid=\"" + ssid + "\"\n    psk=\"" + psk + "\"\n}\" >> /etc/wpa_supplicant/" + location + "\'"
echo_command = "network={\n    ssid=\"" + ssid + "\"\n    psk=\"" + psk + "\"\n}"
full_command = "sudo echo " + echo_command + " >> /etc/wpa_supplicant/" + location
print(full_command)
os.system(full_command)
