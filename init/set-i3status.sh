#!/usr/bin/zsh -f
# This is a simple script to fix i3status battery and wifi info
cd ~/.config/i3
if [[ -e `which acpi` ]]
then
	battery_id=`acpi -b | cut -d ' ' -f 2 | grep -o '[0-9]*'`
	sed -i "/battery/s/1/${battery_id}/" i3status
else
	echo "acpi is not installed. i3status battery info may not be correct"
fi
iface_name=`iw dev | grep "Interface" | cut -d ' ' -f 2`
sed -i "/wireless/s/wlp1s0/${iface_name}/" i3status
# Remove mpd reference from status list
sed -i "/\"mpd\"/d" i3status
# Remove mpd status config lines
sed -i "/mpd/,+4 d" i3status
cd