# Use `hub` by default for git
if [[ -e "$(command -v hub)" ]]
then
	eval "$(hub alias -s)"
fi

alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'

alias gb='git branch'
alias gba='git branch -a'
alias gbda='git branch --merged | command grep -vE "^(\*|\s*master\s*$)" | command xargs -n 1 git branch -d'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'

alias gc='git commit -v'
alias gc!='git commit -v --amend'

alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recursive'

alias gcm='git checkout master'
alias gco='git checkout'
alias gcp='git cherry-pick'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdt='git diff-tree --no-commit-id --name-only -r'

alias gf='git fetch'
alias gfa='git fetch --all --prune'

alias gl='git pull'

alias glol="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glog='git log --oneline --decorate --color --graph'

alias gm='git merge'
alias gmom='git merge origin/master'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpv='git push -v'

alias gr='git remote'
alias gra='git remote add'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'

alias grh='git reset HEAD --'
alias grhh='git reset HEAD --hard'

alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'

alias gsb='git status -sb'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash'

alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'

alias gsu='git submodule update'

alias gts='git tag -s'

alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--"'
