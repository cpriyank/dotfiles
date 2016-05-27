#!/usr/bin/env zsh
#
# Notify to look out or away to reduce eye strain with customized notification
var=$(<todo)
notify-send -u critical "${var}"
