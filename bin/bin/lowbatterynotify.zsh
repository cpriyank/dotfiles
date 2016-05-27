#!/usr/bin/zsh -f
# This is a simple script to notify on low battery via libnotify
battery_level=`acpi -b | cut -d ' ' -f 4 | grep -o '[0-9]*'`
charging_status=`acpi -b | cut -d ',' -f 1 | cut -d ' ' -f 3`
if [[ $battery_level -le 20 && $charging_status != 'Charging' ]];
then notify-send -u critical "Battery level is $battery_level" "Please connect the charger now"
fi