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

# TODO: ensure that these utils exist on the system

# note that setxkbmap commands do not have ' &' appended to them to avoid race
# conditions
# enable restart X with ctrl_alt_bksp
setxkbmap -option terminate:ctrl_alt_bksp
# Swap Caps lock with left control
setxkbmap -option ctrl:swapcaps
# map menu key as windows key
# check your /usr/share/X11/xkb/rules/evdev.lst to see what options are available
setxkbmap -option altwin:menu_win

~/bin/external-monitor.bash &
[[ -f ~/.Xresources ]] && xrdb ~/.Xresources &
pactl set-sink-volume 0 '20%' &
xset -b & # disable bell
xset r rate 400 100 & # faster key repeat rate
[[ -e ~/.config/picom.conf ]] && picom --experimental-backends --config ~/.config/picom.conf -b &
[[ -e ~/Pictures/wallpapers ]] && feh --randomize --bg-fill ~/Pictures/wallpapers/* &
dunst &
# clipit &
klipper &
stretchly &
redshift -o -l 47.61:-122.33 -t 4500:2800 &
# Remember that lines following a command using exec would be ignored
exec i3 # -V >> ~/.cache/i3/i3log-$(date +'%F-%k-%M-%S') 2>&1
# exec startplasma-x11
