import os

def update_files():
    with open("stage2S/01-sys-tweaks/01-run.sh", "r") as sysrun:
        for line in sysrun:
            print(line)
            if(line.startswith("install")):
                os.system("sudo" + line)
            else:
                break

    with open("stage2S/02-net-tweaks/01-run.sh", "r") as netrun:
        for line in netrun:
            print(line)
            if(line.startswith("install")):
                os.system("sudo" + line)
            else:
                break

update_files()