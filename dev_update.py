import os

def update_files():
    with open("stage2S/01-sys-tweaks/01-run.sh", "r") as sysrun:
        sysrun.readline()
        for line in sysrun:
            if(line.startswith("install")):
                vals = line.split(" ")
                if(vals[3] != "-d"):
                    vals[3] = "stage2S/01-sys-tweaks/" + vals[3]
                os.system("sudo " + " ".join(vals))

    with open("stage2S/02-net-tweaks/01-run.sh", "r") as netrun:
        netrun.readline()
        for line in netrun:
            if(line.startswith("install")):
                if(line.startswith("install")):
                vals = line.split(" ")
                if(vals[3] != "-d"):
                    vals[3] = "stage2S/02-net-tweaks/" + vals[3]
                os.system("sudo " + " ".join(vals))


update_files()