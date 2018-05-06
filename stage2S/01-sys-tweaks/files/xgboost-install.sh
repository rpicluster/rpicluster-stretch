#XGBOOST SETUP
if [ ! -d "/home/pi/nfs/packages/xgboost" ]; then
    sudo git clone --recursive https://github.com/dmlc/xgboost /home/pi/nfs/packages/xgboost
fi
cd /home/pi/nfs/packages/xgboost
sudo sed -i '22s/.*/export CFLAGS = -O3 $(WARNFLAGS)/' Makefile
make -j4
cd /home/pi/nfs/packages/xgboost/python-package; sudo python3 setup.py install