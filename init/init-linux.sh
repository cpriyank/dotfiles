#!/usr/bin/env bash
if [[ -x "$(command -v pacman)" ]]; then
	echo "Detected Arch GNU/Linux..."
	bash init-archlinux.sh
elif [[ -x "$(command -v apt)" ]]; then
	echo "Detected Ubuntu..."
	bash init-ubuntu.sh
fi
