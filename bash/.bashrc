[[ -n "$PS1" ]] && source ~/.bash_profile

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

test -r "~/.dircolors" && eval $(dircolors ~/.dircolors)
