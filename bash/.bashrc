[[ -n "$PS1" ]] && source ~/.bash_profile

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

test -r "~/.dircolors" && eval $(dircolors ~/.dircolors)
