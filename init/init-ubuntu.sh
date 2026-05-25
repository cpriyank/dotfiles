#!/usr/bin/env bash
set -euo pipefail

echo "Will install a few packages now..."

packages=(
	# Keep in sync with nix/.config/home-manager/home.nix home.packages.
	bat
	git
	git-delta
	direnv
	fd-find
	ffmpeg
	fzf
	gdu
	gh
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
	npm
	curl
	pandoc
	rclone
	ripgrep
	rsync
	stow
	fonts-0xproto
	tmux
	trash-cli
	vim
	zoxide
)

sudo apt update
sudo apt install -y "${packages[@]}"
