#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Necessary packages
brew install stow zsh zsh-syntax-highlighting zsh-autosuggestions go python3\
	youtube-dl mpv luajit neovim ncdu

# Install more recent versions of some macOS tools.
# brew install vim --with-luajit --with-override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh

# Install other useful binaries.
brew install ripgrep dark-mode imagemagick rename grc
dark-mode

# Set zsh as default shell
# sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Recommended way of installing spacemacs replacing mac os emacs
# brew tap d12frosted/emacs-plus
# brew install emacs-plus --HEAD --with-natural-title-bars
# brew linkapps emacs-plus

# Remove outdated versions from the cellar.
brew cleanup

# Install vim-plug for vim
#curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -o monokai.itermcolors https://raw.githubusercontent.com/chriskempson/base16-iterm2/master/base16-monokai.dark.256.itermcolors
open monokai.itermcolors
rm monokai.itermcolors

# pip install yapf bpython jedi
