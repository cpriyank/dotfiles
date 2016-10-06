#!/usr/bin/env zsh
#
# Notify to look out or away to reduce eye strain with customized notification
if [[ -s todo ]]
then
	var=$(<todo)
	notify-send -u critical "{${var}}"
else
	notify-send -u critical "Winter is Coming!"
fi
