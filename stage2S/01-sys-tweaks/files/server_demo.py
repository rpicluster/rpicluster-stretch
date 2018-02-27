import zerorpc
import random

class ColorPicker(object):

    leases = open("/var/lib/misc/dnsmasq.leases", "r")
    leases = leases.readlines()
    machines = len(leases)
    colors = [[] for i in range(machines)]

    def init(self, index):
	index = index - 1
        r = random.randrange(0, 256)
        g = random.randrange(0, 256)
        b = random.randrange(0, 256)
        self.colors[index] = [r, g, b]
	return self.colors[index]

    def getNodes(self):
	return self.machines

    def setRGB(self, index, color_list):
	index = index - 1
	if(index == 0):
		self.colors[1] = self.colors[index]
		self.colors[3] = self.colors[index]
		self.colors[4] = self.colors[index]

	if(index == 1):
		self.colors[0] = self.colors[index]
		self.colors[2] = self.colors[index]
		self.colors[3] = self.colors[index]
		self.colors[4] = self.colors[index]
		self.colors[5] = self.colors[index]

	if(index == 2):
		self.colors[1] = self.colors[index]
		self.colors[4] = self.colors[index]
		self.colors[5] = self.colors[index]

	if(index == 3):
		self.colors[0] = self.colors[index]
		self.colors[1] = self.colors[index]
		self.colors[4] = self.colors[index]
		self.colors[6] = self.colors[index]
		self.colors[7] = self.colors[index]

	if(index == 4):
		self.colors[0] = self.colors[index]
		self.colors[1] = self.colors[index]
		self.colors[2] = self.colors[index]
		self.colors[3] = self.colors[index]
		self.colors[5] = self.colors[index]
		self.colors[6] = self.colors[index]
		self.colors[7] = self.colors[index]
		self.colors[8] = self.colors[index]

	if(index == 5):
		self.colors[1] = self.colors[index]
		self.colors[2] = self.colors[index]
		self.colors[4] = self.colors[index]
		self.colors[7] = self.colors[index]
		self.colors[8] = self.colors[index]

	if(index == 6):
		self.colors[3] = self.colors[index]
		self.colors[4] = self.colors[index]
		self.colors[7] = self.colors[index]

	if(index == 7):
		self.colors[3] = self.colors[index]
		self.colors[4] = self.colors[index]
		self.colors[5] = self.colors[index]
		self.colors[6] = self.colors[index]
		self.colors[8] = self.colors[index]

	if(index == 8):
		self.colors[4] = self.colors[index]
		self.colors[5] = self.colors[index]
		self.colors[7] = self.colors[index]

	# self.colors[(index + 1) % machines] = self.colors[index]
       	self.colors[index] = color_list
	print(self.colors)

    def getRGB(self, index):
	index = index - 1
        return self.colors[index % len(self.colors)]

s = zerorpc.Server(ColorPicker())
s.bind("tcp://192.168.0.254:4444")
print("Running...")
s.run()
