from fabric.api import *

class FabricException(Exception):
    pass

def config_ip(num):
    with settings(warn_only = True):
        with cd('/rpicluster/config'):
            run('sudo python calibrate_touchless.py')
        with cd('/etc'):
            run('sudo chmod 777 hostname')
            run('sudo chmod 777 hosts')
            run('sudo cp hosts.orig hosts')
            run('sudo echo node{} > hostname'.format(num))
            run('sudo echo "#MPI CLUSTER SETUP" >> /etc/hosts')
            run('sudo echo "192.168.1.254    rpicluster" >> /etc/hosts')
            run('sudo echo "192.168.1.{}      node{}" >> /etc/hosts'.format(num, num))
            run('sudo chmod 644 hostname')
            run('sudo chmod 644 hosts')
        run('sudo reboot -h now')

def send_SSH_keys(ssh_key):
    run('mkdir ~/.ssh/')
    run('echo {} >> ~/.ssh/authorized_keys'.format(ssh_key))

def update():
    run('sudo rm -rf /var/lib/apt/lists/* -f')
    run('sudo apt-get update && sudo apt-get upgrade -y')

def reboot():
    run('sudo reboot -h now')

def shutdown():
    run('sudo shutdown -h now')

def pingall():
    with settings(abort_exception = FabricException):
        try:
            run('cd /rpicluster')
            print(0)
            return 0
        except FabricException:
            print(1)
            return 1

def install(package):
    run("sudo apt get install {} -y".format(package))
