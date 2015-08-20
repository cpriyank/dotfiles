#!/usr/bin/zsh -f
# This is a simple script to notify when the CPU temperature is too high why lm_sensors
current_temp=`sensors | grep "Core 0" | cut -b 18-19`
if [[ $current_temp -ge 70 ]];
then notify-send "CPU temperature too high" "Find out what's causing this!"
fi