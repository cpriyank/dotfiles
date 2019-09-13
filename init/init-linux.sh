#!/usr/bin/env bash
echo "Installing inconsolata fonts..."
mkdir -p ~/.local/share/fonts/inconsolata
cd ~/.local/share/fonts/inconsolata
curl -o inconsolatab.ttf "https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20Bold%20for%20Powerline.ttf"
curl -o inconsolata.otf "https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf"
curl -o LICENCE.txt "https://github.com/powerline/fonts/raw/master/Inconsolata/LICENSE.txt"
# todo: install fura code instead
fc-cache -fv
if [[ -x "$(command -v pacman)" ]]; then
	echo "Detected Arch GNU/Linux..."
	bash init-archlinux.sh
elif [[ -x "$(command -v apt)" ]]; then
	echo "Detected Ubuntu..."
	bash init-ubuntu.sh
fi
