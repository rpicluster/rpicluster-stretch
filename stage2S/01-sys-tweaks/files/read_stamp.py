# purpose: read the stamp and give back the network name and password

network_name = raw_input("Enter a network name: ")
password = raw_input("Enter a password: ")
network_name = ''.join(format(ord(x), 'b') for x in network_name)
password = ''.join(format(ord(x), 'b') for x in password)

def read_stamp(magic_num, file):
    pos = 0
    fd = open(file, 'rb')
    char = ord(fd.read(1))
    first = "" # first is the first half of the image, including the magic number
    while(char != None):
        first += chr(char)
        if(char == ord(magic_num[pos]) and pos == len(magic_num)-1):
            # print("Found point")
            break
        elif(char == ord(magic_num[pos])):
            pos = pos + 1
        else:
            pos = 0
        char = ord(fd.read(1))
    network_name_length = len(network_name)
    password_length = len(password)
    name = fd.read(network_name_length)
    print(name + " : " + bin_to_string(name))
    passw = fd.read(password_length)
    print(passw + " : " + bin_to_string(passw))

def bin_to_string(binary_string):
    return ''.join(format(chr(int(binary_string[i:i+7], 2))) for i in range(0, len(binary_string), 7))

read_stamp("0100010001000001010101110100000101000101", "/boot/stamp")
