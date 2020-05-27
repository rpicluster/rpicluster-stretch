#read the stamp and give back the network name and password
def read_stamp(magic_num, file):
    pos = 0
    fd = open(file, 'rb')
    char = ord(fd.read(1))
    first = "" # first is the first half of the image, including the magic number
    while(char != None):
        first += chr(char)
        if(char == ord(magic_num[pos]) and pos == len(magic_num)-1):
            break
        elif(char == ord(magic_num[pos])):
            pos = pos + 1
        else:
            pos = 0
        char = ord(fd.read(1))
    # use the length of the network and the password to read instead of asking again for input.
    len_network = fd.read(8)
    len_network = int(len_network, 2)
    len_pass = fd.read(8)
    len_pass = int(len_pass, 2)
    name = fd.read(len_network)
    passw = fd.read(len_pass)
    return [bin_to_string(name), bin_to_string(passw)]

def bin_to_string(binary_string):
    return ''.join(format(chr(int(binary_string[i:i+8], 2))) for i in range(0, len(binary_string), 8))