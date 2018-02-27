#!/bin/bash
sudo bash revert.sh
event_num=$(python getevent.py)
sudo TSLIB_FBDEVICE=/dev/fb0 TSLIB_TSDEVICE=/dev/input/event$event_num ts_calibrate
