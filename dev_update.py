import os

def update_files():
    with open("stage2S/01-sys-tweaks/01-run.sh", "r") as sysrun:
        sysrun.readline()
        for line in sysrun:
            if(line.startswith("install")):
                print(line)

    with open("stage2S/01-net-tweaks/01-run.sh", "r") as netrun:
        netrun.readline()
        for line in netrun:
            if(line.startswith("install")):
                print(line)


update_files()