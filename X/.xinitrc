#!/bin/bash
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [[ -x "$f" ]] && . "$f"
  done
  unset f
fi

# enable restart X
setxkbmap -option terminate:ctrl_alt_bksp
# Swap Caps lock with left control
setxkbmap -option ctrl:swapcaps

[[ -f ~/.Xresources ]] && xrdb ~/.Xresources
pactl set-sink-volume 0 '20%' &
xset -b & # disable bell
xset r rate 250 60 # faster key repeat rate
compton --config ~/.config/compton.conf -b &
xbacklight -set 10 &
rofi &
dunst &
# xrandr --output DP2-2 --mode 1920x1080 --rate 60.00 --output DP2-1 --mode 1920x1080 --rate 60.00 --right-of DP2-2 --output eDP1 --off
exec i3 # -V >> ~/.cache/i3/i3log-$(date +'%F-%k-%M-%S') 2>&1
