echo "Will install a few packages now..."
# make sure that i3, compton, dunst, pulseaudio-alsa, alsa-utils feh, and rofi are installed
sudo pacman -S i3 compton dunst pulseaudio-alsa alsa-utils feh rofi xsel\
	neovim emacs xorg-xinit redshift stow
cd ~/.dotfiles
stow X bin colors compton dunst i3 nvim spacemacs systemd zathura zsh
git submodules update --init
echo "vim-plug for neovim is already installed. Run :PlugInstall and :UpdateRemotePlugins\
	from within init.vim."
