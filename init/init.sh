#!/usr/bin/env bash
echo "Will download tmux plugin manager tpm now..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
case $(uname) in
    "Linux") bash init-linux.sh ;;
		"FreeBSD") bash init-freebsd.sh ;;
    "Darwin") bash init-darwin.sh ;;
esac
