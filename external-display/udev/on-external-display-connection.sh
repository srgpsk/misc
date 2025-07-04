#!/usr/bin/env bash

### TODO move these to cli args
MIN_TARGET_X_RESOLUTION=3840 # 4K
TARGET_SCALE_FACTOR=1.5
SCALE_FACTOR=1

### detect if there is any display with >=4K is connected
# shellcheck disable=SC2013
# get all active modes > unique > split and take only horizontal res > sort max to min > get top 1
XRES=$(cat /sys/class/drm/card*/modes | uniq | cut -d 'x' -f 1 | sort -bnr | head -1)
if [ "$XRES" -ge $MIN_TARGET_X_RESOLUTION ]; then
  SCALE_FACTOR=$TARGET_SCALE_FACTOR
fi

### apply defined scale factor system-wide
### capturing real user BUS env var for a reason https://stackoverflow.com/questions/20292578/setting-gsettings-of-other-user-with-sudo
sudo -u 'dev' DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" gsettings set org.gnome.desktop.interface text-scaling-factor "$SCALE_FACTOR"

logger "$0 system UI font scaling factor was set to $SCALE_FACTOR"
