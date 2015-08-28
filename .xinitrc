#!/usr/bin/zsh -f
#
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

#eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#export GPG_AGENT_INFO SSH_AUTH_SOCK
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# exec awesome
[[ -f ~/.Xresources ]] && xrdb ~/.Xresources &
/usr/bin/lxpolkit &
udiskie -2 &
pactl set-sink-volume 0 '20%' &
xset -b &
compton --config ~/.config/compton.conf -b &
nitrogen --restore &
rofi &
urxvtd -q -o -f &
dunst &
exec i3 #-V >> ~/.cache/i3/i3log-$(date +'%F-%k-%M-%S') 2>&1
