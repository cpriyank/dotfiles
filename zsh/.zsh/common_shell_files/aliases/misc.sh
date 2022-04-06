## Utility specific aliases
# Use config file for ncmpc
alias ncmpc='command ncmpc --config ~/.config/ncmpc/config'
alias msar='mpc search artist'
alias msal='mpc search album'

# TODO: set environment variable here?
alias v='$EDITOR'

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
alias ppath='echo $PATH | tr -s ":" "\n"'

alias rm='trash' # Also see RM_STAR_SILENT options of Zsh

# Warn on overwrite
alias cp='cp -i -v'
alias mv='mv -i -v'

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

alias rg='rg --hidden --ignore-case'

# Update installed Ruby gems, Homebrew, npm, and their installed packages
alias brew_update="brew -v update; brew upgrade --force-bottle --cleanup; brew cleanup; brew cask cleanup; brew prune; brew doctor; npm-check -g -u"
alias update_brew_npm_gem='brew_update; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update --no-document'

alias fc-monospace="fc-list :spacing=100"