#!/usr/bin/env zsh
#
# Notify to look outside to reduce eye strain with customized notification
if [[ -s todo ]]
then
	var=$(<todo)
	notify-send -u critical "{${var}}"
	xsecurelock
elif [[ -s tips ]]
then
	var=$(<tips)
	notify-send -u critical "{${var}}"
	xsecurelock
elif command -v fortune 2>/dev/null
then
	notify-send -u critical "`fortune dhammapada`"
	xsecurelock
else
	# notify-send -a "Relax" -u critical "Look outside for a while"
	xsecurelock
fi
