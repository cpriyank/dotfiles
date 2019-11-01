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
	notify-send -a "Relax" -u critical "Look outside for a while"
fi
