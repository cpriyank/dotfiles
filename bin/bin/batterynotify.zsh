#!/usr/bin/zsh -f
# This is a simple script to notify on low battery via libnotify
if [[ -e `which acpi` ]]
then
	battery_level=`acpi -b | cut -d ' ' -f 4 | grep -o '[0-9]*'`
	charging_status=`acpi -b | cut -d ',' -f 1 | cut -d ' ' -f 3`
	if [[ $battery_level -le 40 && $charging_status != 'Charging' ]];
	then notify-send -u critical "Battery level is $battery_level" "Please connect the charger now"
	elif [[ $battery_level -ge 90 && $charging_status == 'Charging' ]];
	then notify-send -u normal "Battery level is $battery_level" "Please remove the charger now"
	fi
else
	echo "acpi not installed"
fi