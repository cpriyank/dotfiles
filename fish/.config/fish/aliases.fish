## Utility specific aliases
if which nvim > /dev/null
	alias v="nvim"
else if which vim > /dev/null
  alias v="vim"
else
  echo vim or neovim is not installed.
end

alias l="la"

alias m='tmux -f ~/.tmux/config'
alias a='tmux attach'

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

alias rm='rm -i' # Also see RM_STAR_SILENT options of Zsh

# Warn on overwrite
alias cp='cp -i'
alias mv='mv -i'

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

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls"

alias ga='git add'
alias gc='git commit -v'
alias gsb='git status -sb'
alias gd='git diff'
alias glola="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"

alias gp='git push'
alias gpd='git push --dry-run'
alias grh='git reset HEAD --'