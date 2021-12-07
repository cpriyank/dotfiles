#!/usr/bin/env bash

# Detects monitors; if external monitors is connected,
# disables laptop screen

# if condition test can be more reliable here
if [[ $(xrandr --listmonitors | wc -l) == 3 ]];
then
	# Find names of your outputs using command `xrandr -q`
	notify-send "turning off laptop screen"
	xrandr --output eDP-1 --off
	feh --bg-fill --randomize ~/Pictures/wallpapers/
else
	notify-send "turning on laptop screen"
	xrandr --auto
	feh --bg-fill --randomize ~/Pictures/wallpapers/
fi