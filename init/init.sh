#!/usr/bin/env bash
curl --create-dirs -o ~/.zsh/plugs/z.sh "https://raw.githubusercontent.com/rupa/z/master/z.sh"
gem install colorls
echo "Will download vim-plug for vim now..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
case $(uname) in
    "Linux") bash init-linux.sh ;;
		"FreeBSD") bash init-freebsd.sh ;;
    "Darwin") bash init-darwin.sh ;;
esac
