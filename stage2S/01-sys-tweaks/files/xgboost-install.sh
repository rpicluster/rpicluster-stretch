#XGBOOST SETUP
if [ ! -d "/home/pi/nfs/packages/xgboost" ]; then
    sudo git clone --recursive https://github.com/dmlc/xgboost /home/pi/nfs/packages/xgboost
    sudo sed -i '22s/.*/export CFLAGS = -O3 $(WARNFLAGS)/' /home/pi/nfs/packages/xgboost/rabit/Makefile
fi
#sudo apt-get -y install python3-numpy
#sudo apt-get -y install python3-scipy
#sudo apt-get -y install python3-sklearn
#sudo apt-get -y install python-setuptools
#sudo apt-get -y install libblas-dev liblapack-dev libatlas-base-dev gfortran
cd /home/pi/nfs/packages/xgboost
sudo make -j4
cd /home/pi/nfs/packages/xgboost/python-package; sudo python3 setup.py install

