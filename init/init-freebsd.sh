echo "Will install a few packages now..."
command -v sudo >/dev/null 2>&1 || { echo >&2 "sudo is not installed. Install sudo, visudo from shell and allow login to your group. Aborting."; exit 1; }
# make sure that i3, compton, dunst, pulseaudio-alsa, alsa-utils feh, and rofi are installed
sudo pacman -S i3 i3status compton dunst feh rofi \
	neovim redshift xstow
cd ~/.dotfiles
xstow X bin colors compton dunst i3 nvim zathura zsh
git submodules update --init
echo "vim-plug for neovim is already installed. Run :PlugInstall and :UpdateRemotePlugins\
	from within init.vim."