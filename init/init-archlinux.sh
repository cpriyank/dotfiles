echo "Will install a few packages now..."
# make sure that essentials are installed
sudo pacman -S i3 picom dunst pamixer pipewire pipewire-pulse feh rofi \
	neovim xorg-xinit redshift stow bat fzf fd ripgrep z texlive-bin texlive-core texlive-science\
	texlive-latexextra
cd ~/.dotfiles
stow X bin colors compton dunst i3 nvim spacemacs systemd zathura zsh
git submodules update --init
echo "vim-plug for neovim is already installed. Run :PlugInstall and :UpdateRemotePlugins\
	from within init.vim."

# TODO: Install arphic, noto emoji fonts

# Fonts
sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
