import pygame
import zerorpc
import socket
import fcntl
import struct
import random
import time
import os
import subprocess
p = subprocess.check_output(["cat", "/proc/bus/input/devices"])
result = p.decode('utf-8').split("\n")

whichEvent = 0
for i in range(0, len(result)):
    if("Touchscreen" in result[i]):
        whichEvent = result[i + 4].split(" ")[2][5]

os.environ["SDL_FBDEV"] = "/dev/fb0"
os.environ["SDL_MOUSEDRV"] = "TSLIB"
os.environ["SDL_MOUSEDEV"] = "/dev/input/event" + str(whichEvent)

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

pygame.init()

size = (pygame.display.Info().current_w, pygame.display.Info().current_h)
screen = pygame.display.set_mode(size, pygame.FULLSCREEN)

c = zerorpc.Client()
c.connect("tcp://192.168.0.254:4444")
ip = get_ip_address('eth0')
i = 0
dots = 0
while dots != 3:
    if(ip[i] == '.'):
        dots += 1
    i+=1
index = int(ip[i:])

rgb = c.init(index)
screen.fill((rgb[0], rgb[1], rgb[2]))
# need to implement locking after init, cannot get RGB
# if list hasn't been populated yet.
time.sleep(2) 

while True:
    # rgb = getRGB(index)
    # c.setRGB(index, [r, g, b])

    # use neighbor colors to display.
    # screen.fill((rgb[0], rgb[1], rgb[2]))
    for event in pygame.event.get():
        # while(event.type != pygame.MOUSEBUTTONDOWN):
        #    continue
	if event.type == pygame.MOUSEBUTTONDOWN:
       		newr = random.randrange(0, 256)
       		newg = random.randrange(0, 256)
		newb = random.randrange(0, 256)
		c.setRGB(index , [newr, newg, newb])

    rgb = c.getRGB(index)
    screen.fill((rgb[0], rgb[1], rgb[2]))

    pygame.display.update()

pygame.quit()
