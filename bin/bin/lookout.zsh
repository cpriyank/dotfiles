#!/usr/bin/env zsh
#
# Notify to look outside to reduce eye strain with customized notification
if [[ -s todo ]]
then
	var=$(<todo)
	notify-send -u critical "{${var}}"
elif [[ -s tips ]]
then
	var=$(<tips)
	notify-send -u critical "{${var}}"
elif command -v fortune 2>/dev/null
then
	notify-send -u critical "`fortune dhammapada`"
else
	mpv --audio-display=no "$HOME/bin/minutes.mp3"
	notify-send -a "Relax" -u critical "Look outside for a while"
	notify-send -a "Breathe" -u normal -i '/usr/share/icons/elementary/apps/128/internet-web-browser.svg' "Breathe for a minute"
fi
