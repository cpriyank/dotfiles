# If the shell is a login shell, commands are read from /etc/profile and
# then from $ZDOTDIR/.zprofile.


# Start X at login
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

