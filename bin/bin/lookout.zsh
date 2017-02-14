#!/usr/bin/env zsh
#
# Notify to look outside to reduce eye strain with customized notification
if [[ -s todo ]]
then
	var=$(<todo)
	notify-send -u critical "{${var}}"
else
	notify-send -a "Have a break" -u critical "`fortune`"
fi
