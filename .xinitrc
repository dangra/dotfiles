#!/bin/bash
# vim:ft=sh:
PATH=$HOME/bin:$PATH

xhost + &
xset b 5 &
xset r rate 250 100
xset +dpms

XMODMAP=".Xmodmap-`hostname -s`"
[ -r $XMODMAP ]&&xmodmap $XMODMAP

xrdb $HOME/.Xresources

export OOO_FORCE_DESKTOP=gnome

gnome-settings-daemon & # handles themes, starts gnome-screensaver. You may have to use gconf to disable it setting the background.
nm-applet &             # assuming you're using Network Manager
gnome-power-manager &   # for laptops and stuff
gnome-volume-manager &  # for mounting CDs, USB sticks, and such
awesome --config $HOME/.config/awesome/rc-xsession.lua &
wmpid=$!

gnome-volume-control-applet &
system-config-printer-applet &
#ubuntuone-client-applet &
update-notifier --startup-delay=60 &
bluetooth-applet &
gnome-screensaver
ssh-add </dev/null &
wait $wmpid
