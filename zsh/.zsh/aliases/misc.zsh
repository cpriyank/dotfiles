## Utility specific aliases
# Use config file for ncmpc
alias ncmpc='command ncmpc --config ~/.config/ncmpc/config'
alias msar='mpc search artist'
alias msal='mpc search album'

alias v="$EDITOR"

alias m='tmux -f ~/.tmux/config'
alias a='tmux attach'

# cat files with syntax highlighting. Requires Pygmentize
# installed via pip
alias c="pygmentize -O style=monokai -f console256 -g"

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

alias matlab='matlab -nosplash -nodesktop'
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

# Redshift aliases. For saving eyes, seriously.
# Gandhinagar coordinates
alias shantib='redshift -o -l 23.22:72.68'
# Seattle coordinates  
alias shanti='redshift -o -l 47.61:-122.33 -t 4500:2800'
# Reset color
alias ashanti='redshift -x'

# exec previous command with sudo
alias please='sudo $(fc -ln -1)'

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls"
