## Utility specific aliases
# Use config file for ncmpc
alias ncmpc='command ncmpc --config ~/.config/ncmpc/config'
alias msar='mpc search artist'
alias msal='mpc search album'

# ${foo+x} which is a parameter expansion
# '-n' means True if its argument string has non­zero length'
# more on this https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
if [[ -n ${EDITOR+x} ]]; then
	alias v="$EDITOR"
fi

alias m='tmux'
alias a='tmux attach'

# Allow alias expansion after `sudo`
alias sudo='sudo '

# Allow alias expansion after `man`
alias man='man '

# Open vim in readonly mode
alias vr='v -R'

alias scp='scp -p'
alias wget='wget -c'

alias pong='ping -c 3 www.google.com'

alias xrr='xrdb ~/.Xresources'

alias tree='tree -C'

# Make du readable
alias da='du -sch'

# Print path in easier to read, vertical format
alias vpath='echo $PATH | tr -s ":" "\n"'

alias rm='rm -i' # Also see RM_STAR_SILENT options of Zsh

# Warn on overwrite
alias cp='cp -i'
alias mv='mv -i'

# Remove current empty directory nicely
alias rmdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'

# Download video by URL from STDIN
alias apo='youtube-dl'
# Download videos from the list of URLs from a file
alias apone='youtube-dl -a'

alias asong='youtube-dl -f 251'

# just play audio from a video file or url
alias p='mpv --no-video'

# Redshift aliases. For saving eyes
# Gandhinagar coordinates
alias shantib='redshift -o -l 23.22:72.68'
# Seattle coordinates  
alias shanti='redshift -o -l 47.61:-122.33 -t 4500:2800'
# Reset color
alias ashanti='redshift -x'

# exec previous command with sudo
alias please='sudo $(fc -ln -1)'

# Recursively delete `.DS_Store` files
alias cleands="find . -name '*.DS_Store' -type f -ls"

alias k="kak"
