#!/usr/bin/env bash
mv $1 ~/.local/share/fonts/
cd ~/.local/share/fonts/
unzip $1
rm $1
fc-cache -fv