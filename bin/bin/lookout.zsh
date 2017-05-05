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
elif [[ -e `which fortune` ]]
then
	notify-send -u normal "`fortune -a`"
else
	notify-send -a "Relax" -u normal "Look outside for a while"
fi
