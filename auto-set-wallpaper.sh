#! /bin/bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" 

cd /home/midorikawa/Pictures/arsenixc_wallpaper/

if [ $(date +%H) -ge 6 -a $(date +%H) -lt 17 ]
then
    gsettings set org.gnome.desktop.background picture-uri "file:///home/midorikawa/Pictures/arsenixc_wallpaper/$(ls d-*| shuf -n1)"
elif [ $(date +%H) -ge 17 -a $(date +%H) -lt 19 ]
then
    gsettings set org.gnome.desktop.background picture-uri "file:///home/midorikawa/Pictures/arsenixc_wallpaper/$(ls s-*| shuf -n1)"
else
    gsettings set org.gnome.desktop.background picture-uri "file:///home/midorikawa/Pictures/arsenixc_wallpaper/$(ls n-*| shuf -n1)"
fi
