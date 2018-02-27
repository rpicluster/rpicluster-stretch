import subprocess
p = subprocess.check_output(["cat", "/proc/bus/input/devices"])
result = p.decode('utf-8').split("\n")
whichEvent = 0
for i in range(0, len(result)):
    if("Touchscreen" in result[i]):
        whichEvent = result[i + 4].split(" ")[2][5]

print(whichEvent)
