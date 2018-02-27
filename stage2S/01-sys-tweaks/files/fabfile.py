from fabric.api import *

def calibrate_screen():
    with cd('/rpicluster/config'):
        run('sudo bash event_config.sh')

def config_ip():
	with cd('/rpicluster/config'):
		run('sudo python calibrate_touchless.py')

def config_ip_touch():
	with cd('/rpicluster/config'):
		run('sudo python calibrate.py')

def send_SSH_keys(ssh_key):
	run('mkdir ~/.ssh/')
	run('touch ~/.ssh/authorized_keys')
	run('echo {} >> ~/.ssh/authorized_keys'.format(ssh_key))

def run_demo():
	with cd('/rpicluster/config'):
		run('sudo python demo.py')
