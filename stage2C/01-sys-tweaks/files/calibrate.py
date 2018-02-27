# Highlight-able menu in Pygame
#
# To run, use:
#     python3 button.py
#
# You should see a window with three grey menu options on it.  Place the mouse
# cursor over a menu option and it will become white.
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

import pygame
import zerorpc
class Option:

    hovered = False
    def __init__(self, text, pos):
        self.text = text
        self.pos = pos
        self.set_rect()
        self.draw()

    def draw(self):
        self.set_rend()
        screen.blit(self.rend, self.rect)

    def set_rend(self):
        self.rend = menu_font.render(self.text, True, self.get_color())

    def get_color(self):
        if self.hovered:
            return (255, 255, 255)
        else:
            return (100, 100, 100)

    def get_text(self):
        return self.text

    def set_rect(self):
        self.set_rend()
        self.rect = self.rend.get_rect()
        self.rect.topleft = self.pos

#Returns MAC Address in xx:xx:xx:xx:xx:xx format
from uuid import getnode as get_mac
def getMacAddr():

        mac = get_mac()
        print("mac Decimal: {0}".format(mac))
        mac = hex(mac).split('x')[-1]
        new_mac = ""
        for x in range(12):
                if(x%2 == 0 and x != 0):
                        new_mac += ":"

                new_mac += mac[x]

        print("mac hex: {0}".format(new_mac))
        return new_mac

pygame.init()

size = (pygame.display.Info().current_w, pygame.display.Info().current_h)
screen = pygame.display.set_mode(size, pygame.FULLSCREEN)
menu_font = pygame.font.Font(None, 80)
regular_font = pygame.font.Font(None, 40)
options = [Option("CALIBRATING . . .", (size[0] / 2 - 185, size[1] / 2 - 100)), Option("QUIT", (size[0] / 2 - 75, size[1] / 2))]

while True:
    pygame.event.pump()
    screen.fill((0, 0, 0))
    quit = 0
    for option in options:
        if option.rect.collidepoint(pygame.mouse.get_pos()):
            option.hovered = True
            if option.get_text() == "QUIT":
                quit = 1
            if option.get_text() == "CALIBRATING . . .":
                quit = 1
                c = zerorpc.Client()
                c.connect("tcp://192.168.0.254:4444")
                mac = getMacAddr()
                print(c.sendIP(mac))
        else:
            option.hovered = False
        option.draw()
    screen.blit(regular_font.render("(Press screen)", False, (100,100,100)), (size[0] / 2 - 95, size[1] / 2 + 100))
    pygame.display.update()
    if quit == 1:
        break
pygame.quit()

