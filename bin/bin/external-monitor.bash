#!/usr/bin/env bash

# Detects monitors; if external monitor "DP-2" or "HDMI-1"
# is connected, disable laptop screen
if xrandr --listmonitors | grep -q "DP-2\|HDMI-1";
then
	notify-send "turning off laptop screen"
	xrandr --output eDP-1 --off
	# xrandr --auto
else
	notify-send "turning on laptop screen"
	xrandr --auto
fi
echo "done"
feh --bg-fill --randomize ~/Pictures/wallpapers/
