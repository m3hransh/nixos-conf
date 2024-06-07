#!/usr/bin/env bash

op=$(echo -e " Poweroff\n Reboot\n Suspend\n Lock" | wofi -i --width 250 --height 210 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $op in
poweroff) ;&
reboot) ;&
suspend)
	systemctl $op
	;;
lock)
	exec swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2
	;;
esac
