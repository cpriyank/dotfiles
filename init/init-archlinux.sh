#!/usr/bin/env bash
set -euo pipefail

echo "Will install a few packages now..."

packages=(
	# Desktop/bootstrap packages for this Arch profile.
	i3
	picom
	dunst
	pamixer
	pipewire
	pipewire-pulse
	feh
	rofi
	xorg-xinit
	redshift
	z
	texlive-bin
	texlive-core
	texlive-science
	texlive-latexextra
	fish
	git

	# Keep in sync with nix/.config/home-manager/home.nix home.packages.
	bat
	git-delta
	direnv
	fd
	ffmpeg
	fzf
	gdu
	github-cli
	ghostscript
	tar
	gping
	graphicsmagick
	imagemagick
	jq
	lazygit
	localsend
	luajit
	lsd
	mpv
	neovim
	nodejs
	# pandoc # large set of dependencies
	pyright
	rclone
	ripgrep
	rsync
	stow
	ttf-0xproto-nerd
	tmux
	trash-cli
	uv
	vim
	zoxide
)

sudo pacman -S --needed "${packages[@]}"

cd ~/.dotfiles
stow X bin colors compton dunst i3 nvim systemd zathura fish
git submodules update --init
echo "vim-plug for neovim is already installed. Run :PlugInstall and :UpdateRemotePlugins\
	from within init.vim."

# TODO: Install arphic, noto emoji fonts

# Fonts
sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
