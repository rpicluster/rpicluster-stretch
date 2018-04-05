from fabric.api import *

def config_ip():
    with cd('/rpicluster/config'):
        run('sudo python calibrate_touchless.py')
    run('sudo reboot -h now')

def send_SSH_keys(ssh_key):
    run('mkdir ~/.ssh/')
    run('touch ~/.ssh/authorized_keys')
    run('echo {} >> ~/.ssh/authorized_keys'.format(ssh_key))
