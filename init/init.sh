#!/usr/bin/env bash
echo "Will download vim-plug for vim now..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
case $(uname) in
    "Linux") bash init-linux.sh ;;
    "Darwin") bash init-darwin.sh ;;
esac
