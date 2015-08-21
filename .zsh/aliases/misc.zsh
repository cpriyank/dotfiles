## Utility specific aliases
# Use config file for ncmpc
alias music='ncmpc --config ~/.config/ncmpc/config'

alias v='vim'

# Allow alias expansion after sudo
alias sudo='sudo '

# Open vim in readonly mode
alias vr='vim -R'

alias scp='scp -p'
alias wget='wget -c'

alias pong='ping -c 3 www.google.com'

alias xrr='xrdb ~/.Xresources'

alias matlab='matlab -nosplash -nodesktop'
alias tree='tree -C'

# Make du readable
alias da='du -sch'

# Print path in easier to read, vertical format
alias vpath='echo $PATH | tr -s ":" "\n"'

alias rm='rm -i' # Also see RM_STAR_SILENT options of Zsh

# Remove current empty directory nicely
alias rmdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'

# Download video by URL from STDIN
alias apo='youtube-dl'
# Download videos from the list of URLs from a file
alias apone='youtube-dl -a'

# Redshift aliases. For saving eyes, seriously.
# Gandhinagar coordinates
alias shantib='redshift -o -l 23.22:72.68'
# Philly coordinates  
alias shanti='redshift -o -l 39.95:-75.19'
# Reset color
alias ashanti='redshift -x'

