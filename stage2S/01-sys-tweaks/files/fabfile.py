from fabric.api import *

def config_ip(num):
    with settings(warn_only = True):
        rv = False
        with cd('/rpicluster/config'):
            run('sudo python calibrate_touchless.py')
        with cd('/etc'):
            run('sudo echo node{} > hostname'.format(num))
        run('sudo reboot -h now')

def send_SSH_keys(ssh_key):
    run('mkdir ~/.ssh/')
    run('touch ~/.ssh/authorized_keys')
    run('echo {} >> ~/.ssh/authorized_keys'.format(ssh_key))
