#!/usr/bin/env bash

op=$(echo -e " Poweroff\n Reboot\n Suspend\n Lock" | wofi -i --width 250 --height 210 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $op in
poweroff) ;&
reboot) ;&
suspend)
	systemctl $op
	;;
lock)
	swaylock
	;;
esac
