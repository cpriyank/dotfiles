#!/usr/bin/env bash
case $(uname) in
    "Linux") bash init-linux.sh ;;
    "FreeBSD") bash init-freebsd.sh ;;
    "Darwin") bash init-darwin.sh ;;
esac
