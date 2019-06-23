# beautify ls, show git status if available
# some of these override existing aliases
# todo: disable this for large projects?
alias ls="colorls --git-status --sort-dirs"
alias l="colorls --long --git-status --sort-dirs"
alias la="colorls --long --almost-all --human-readable --git-status --sort-dirs"
alias lsd="colorls --dirs"
alias lsf="colorls --files --git-status"
alias lst="colorls --tree"
# sort output by modification time
alias lt="colorls --git-status --sort-dirs -t"
