## Add some colors to your workspace(s)
# Detect OS and determine proper flag to colorize
if ls --color=auto / >/dev/null 2>&1; then # GNU/Linux ls
    colorflag="--color"
elif ls -G / >/dev/null 2>&1; then # OSX ls
    colorflag="-G"
fi

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
# Thanks @matthiasbynes
alias grep='grep --color=auto'

# List all files in a nicely detailed, colored format
alias l="ls -hlF ${colorflag}"

# Same as above, with dotfiles
alias la="ls -hAlF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
# Only empty directories
alias lse='command ls -d ${colorflag} *(/^F)'

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Only symlinks
alias lsl='command ls -l *(@)'
# Only executables
alias lsx='command ls -l *(*)'
# Only world-{readable,writable,executable} files
alias lsw='command ls -ld *(R,W,X.^ND/)'
# The ten biggest files
alias lsbig="command ls -flh *(.OL[1,10])"
# The ten newest files
alias lsnew="command ls -rtlh *(D.om[1,10])"
# The ten newest directories and ten newest .directories
alias lsnd="command ls -rthdl *(/om[1,10]) .*(D/om[1,10])"

# Color 'less' output
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Navigate directories conveniently
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
