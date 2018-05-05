import os

def update_files():
    with open("stage2S/01-sys-tweaks/01-run.sh", "r") as sysrun:
        sysrun.readline()
        line = sysrun.readline()
        while(not line):
            print(line)
            if(line.startswith("install")):
                os.system("sudo" + line)
            else:
                break
            line = sysrun.readline()

    with open("stage2S/02-net-tweaks/01-run.sh", "r") as netrun:
        netrun.readline()
        line = netrun.readline()
        while(not line):
            print(line)
            if(line.startswith("install")):
                os.system("sudo" + line)
            else:
                break
            line = netrun.readline()

update_files()