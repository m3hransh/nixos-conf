#!/usr/bin/env bash

options=" Poweroff\n Reboot\n Suspend\n Lock"

raw=$(echo -e "$options" | rofi -dmenu -i -p "Power" \
    -theme-str 'window {width: 280px;} listview {lines: 4;}' \
    -hover-select false)
chosen=$(echo "$raw" | sed 's/.*[[:space:]]//' | tr '[:upper:]' '[:lower:]')
case $chosen in
poweroff) ;&
reboot) ;&
suspend)
	systemctl $chosen
	;;
lock)
	exec hyprlock
	;;
esac
