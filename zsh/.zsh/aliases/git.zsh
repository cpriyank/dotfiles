# Use `hub` by default for git
if [[ -e "$(command -v hub)" ]]
then
	eval "$(hub alias -s)"
fi

alias g='git'

alias ga='git add'

alias gc='git commit -v'

alias clone='git clone --recursive'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdt='git diff-tree --no-commit-id --name-only -r'

alias glola="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"

alias gst='git status'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
