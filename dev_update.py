import os

def update_files():
    with open("stage2S/01-sys-tweaks/01-run.sh", "r") as sysrun:
        sysrun.readline()
        for line in sysrun:
            if(line.startswith("install")):
                vals = line.split(" ")
                for x in range(len(vals)):
                    if("files/" in vals[x]):
                        vals[x] = "stage2S/01-sys-tweaks/" + vals[x]
                os.system("sudo " + " ".join(vals))

    with open("stage2S/02-net-tweaks/01-run.sh", "r") as netrun:
        netrun.readline()
        for line in netrun:
            if(line.startswith("install")):
                vals = line.split(" ")
                for x in range(len(vals)):
                    if("files/" in vals[x]):
                        vals[x] = "stage2S/02-net-tweaks/" + vals[x]
                os.system("sudo " + " ".join(vals))


update_files()